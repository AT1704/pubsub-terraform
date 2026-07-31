import base64
import json
import logging
import os
import time
from datetime import datetime, timezone
from typing import Any

from flask import Flask, Response, jsonify, request
from google.cloud import storage

try:
    from .logging_config import configure_logging
except ImportError:
    from logging_config import configure_logging

configure_logging()

logger = logging.getLogger(__name__)

app = Flask(__name__)

BUCKET_NAME = os.environ.get("BUCKET_NAME")


def get_storage_client() -> storage.Client:
    """Create the Cloud Storage client only when it is needed."""
    return storage.Client()


def decode_pubsub_message(
    envelope: dict[str, Any],
) -> tuple[dict[str, Any], str]:
    """
    Decode a wrapped Pub/Sub push message.

    Returns:
        A tuple containing:
        - decoded JSON payload
        - Pub/Sub message ID
    """
    message = envelope.get("message")

    if not isinstance(message, dict):
        raise ValueError(
            "Request body does not contain a valid 'message' object."
        )

    encoded_data = message.get("data")
    message_id = message.get("messageId") or message.get("message_id")

    if not encoded_data:
        raise ValueError("Pub/Sub message does not contain 'data'.")

    if not message_id:
        raise ValueError("Pub/Sub message does not contain a message ID.")

    try:
        decoded_bytes = base64.b64decode(
            encoded_data,
            validate=True,
        )
        decoded_text = decoded_bytes.decode("utf-8")
        payload = json.loads(decoded_text)

    except (
        ValueError,
        UnicodeDecodeError,
        json.JSONDecodeError,
    ) as exc:
        raise ValueError(
            "Pub/Sub message data is not valid base64-encoded JSON."
        ) from exc

    if not isinstance(payload, dict):
        raise ValueError(
            "Decoded event payload must be a JSON object."
        )

    return payload, str(message_id)


def build_object_name(message_id: str) -> str:
    """Build a deterministic Cloud Storage object name."""

    now = datetime.now(timezone.utc)

    return (
        "raw-events/"
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
    """Store a processed Pub/Sub event in Cloud Storage."""

    if not BUCKET_NAME:
        raise RuntimeError(
            "BUCKET_NAME environment variable is not configured."
        )

    object_name = build_object_name(message_id)

    stored_event = {
        "message_id": message_id,
        "received_at": datetime.now(timezone.utc).isoformat(),
        "subscription": envelope.get("subscription"),
        "payload": payload,
    }

    storage_client = get_storage_client()
    bucket = storage_client.bucket(BUCKET_NAME)
    blob = bucket.blob(object_name)

    blob.upload_from_string(
        json.dumps(
            stored_event,
            separators=(",", ":"),
            ensure_ascii=False,
        ),
        content_type="application/json",
    )

    return object_name


@app.get("/health")
def health() -> Response:
    """Return the service health status."""

    return jsonify(
        {
            "status": "healthy",
            "bucket_configured": bool(BUCKET_NAME),
        }
    )


@app.post("/")
def receive_pubsub_message() -> Response:
    """
    Receive a wrapped Pub/Sub push message.

    204 -> Success
    400 -> Invalid Pub/Sub message
    500 -> Internal processing failure
    """

    start_time = time.perf_counter()

    envelope = request.get_json(silent=True)

    if not isinstance(envelope, dict):
        logger.warning(
            "Request body is not valid JSON.",
            extra={
                "event": "invalid_request",
            },
        )

        return jsonify(
            {
                "error": "Request body must be valid JSON.",
            }
        ), 400

    message_id = None

    try:
        payload, message_id = decode_pubsub_message(envelope)

        object_name = write_event_to_gcs(
            payload=payload,
            message_id=message_id,
            envelope=envelope,
        )

        processing_time_ms = round(
            (time.perf_counter() - start_time) * 1000,
            2,
        )

        logger.info(
            "Event uploaded successfully.",
            extra={
                "event": "event_uploaded",
                "message_id": message_id,
                "bucket_name": BUCKET_NAME,
                "object_name": object_name,
                "processing_time_ms": processing_time_ms,
            },
        )

        return Response(status=204)

    except ValueError as exc:
        logger.warning(
            "Invalid Pub/Sub message.",
            extra={
                "event": "invalid_pubsub_message",
                "message_id": message_id,
                "error_type": type(exc).__name__,
                "error_details": str(exc),
            },
        )

        return jsonify(
            {
                "error": "Invalid Pub/Sub message.",
                "details": str(exc),
            }
        ), 400

    except Exception:
        logger.exception(
            "Event processing failed.",
            extra={
                "event": "event_processing_failed",
                "message_id": message_id,
                "bucket_name": BUCKET_NAME,
            },
        )

        return jsonify(
            {
                "error": "Internal processing failure.",
            }
        ), 500


if __name__ == "__main__":
    port = int(os.environ.get("PORT", "8080"))

    app.run(
        host="0.0.0.0",
        port=port,
    )