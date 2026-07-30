import base64
import json
import logging
import os
from datetime import datetime, timezone
from typing import Any

from flask import Flask, Response, jsonify, request
from google.cloud import storage


app = Flask(__name__)

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

BUCKET_NAME = os.environ.get("BUCKET_NAME")

storage_client = storage.Client()


def decode_pubsub_message(envelope: dict[str, Any]) -> tuple[dict[str, Any], str]:
    """
    Decode a wrapped Pub/Sub push message.

    Returns:
        A tuple containing:
        - decoded JSON payload
        - Pub/Sub message ID
    """
    message = envelope.get("message")

    if not isinstance(message, dict):
        raise ValueError("Request body does not contain a valid 'message' object.")

    encoded_data = message.get("data")
    message_id = message.get("messageId") or message.get("message_id")

    if not encoded_data:
        raise ValueError("Pub/Sub message does not contain 'data'.")

    if not message_id:
        raise ValueError("Pub/Sub message does not contain a message ID.")

    try:
        decoded_bytes = base64.b64decode(encoded_data, validate=True)
        decoded_text = decoded_bytes.decode("utf-8")
        payload = json.loads(decoded_text)
    except (ValueError, UnicodeDecodeError, json.JSONDecodeError) as exc:
        raise ValueError("Pub/Sub message data is not valid base64-encoded JSON.") from exc

    if not isinstance(payload, dict):
        raise ValueError("Decoded event payload must be a JSON object.")

    return payload, str(message_id)


def build_object_name(message_id: str) -> str:
    """
    Build a deterministic Cloud Storage object name.

    Using the Pub/Sub message ID helps make repeated deliveries overwrite
    the same object instead of creating duplicate files.
    """
    now = datetime.now(timezone.utc)

    return (
        f"raw-events/"
        f"year={now:%Y}/"
        f"month={now:%m}/"
        f"day={now:%d}/"
        f"{message_id}.json"
    )


def write_event_to_gcs(
    payload: dict[str, Any],
    message_id: str,
    envelope: dict[str, Any],
) -> str:
    if not BUCKET_NAME:
        raise RuntimeError("BUCKET_NAME environment variable is not configured.")

    object_name = build_object_name(message_id)

    stored_event = {
        "message_id": message_id,
        "received_at": datetime.now(timezone.utc).isoformat(),
        "subscription": envelope.get("subscription"),
        "payload": payload,
    }

    bucket = storage_client.bucket(BUCKET_NAME)
    blob = bucket.blob(object_name)

    blob.upload_from_string(
        json.dumps(stored_event, separators=(",", ":"), ensure_ascii=False),
        content_type="application/json",
    )

    return object_name


@app.get("/health")
def health() -> Response:
    return jsonify(
        {
            "status": "healthy",
            "bucket_configured": bool(BUCKET_NAME),
        }
    )


@app.post("/")
def receive_pubsub_message() -> Response:
    envelope = request.get_json(silent=True)

    if not isinstance(envelope, dict):
        logger.warning("Request body is not valid JSON.")
        return jsonify({"error": "Request body must be valid JSON."}), 400

    try:
        payload, message_id = decode_pubsub_message(envelope)

        object_name = write_event_to_gcs(
            payload=payload,
            message_id=message_id,
            envelope=envelope,
        )

        logger.info(
            "Processed Pub/Sub message message_id=%s object=%s",
            message_id,
            object_name,
        )

        return Response(status=204)

    except ValueError as exc:
        # Permanent payload problem. Returning 204 prevents endless retries.
        logger.warning("Rejected invalid message: %s", exc)
        return Response(status=204)

    except Exception:
        # Temporary infrastructure or application failure.
        # Returning 500 tells Pub/Sub to retry the message.
        logger.exception("Failed to process Pub/Sub message.")
        return jsonify({"error": "Internal processing failure."}), 500