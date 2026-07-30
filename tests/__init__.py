import base64
import json
from unittest.mock import Mock

import pytest

from app import main


def build_pubsub_envelope(
    payload: dict,
    message_id: str = "message-123",
) -> dict:
    """Create a Pub/Sub push envelope for tests."""
    encoded_data = base64.b64encode(
        json.dumps(payload).encode("utf-8")
    ).decode("utf-8")

    return {
        "message": {
            "data": encoded_data,
            "messageId": message_id,
        },
        "subscription": (
            "projects/test-project/subscriptions/test-subscription"
        ),
    }


@pytest.fixture
def client():
    main.app.config.update(TESTING=True)

    with main.app.test_client() as test_client:
        yield test_client


def test_decode_pubsub_message_returns_payload_and_message_id():
    envelope = build_pubsub_envelope(
        payload={"order_id": "order-1002", "status": "created"},
        message_id="12345",
    )

    payload, message_id = main.decode_pubsub_message(envelope)

    assert payload == {
        "order_id": "order-1002",
        "status": "created",
    }
    assert message_id == "12345"


def test_decode_pubsub_message_rejects_missing_message():
    with pytest.raises(
        ValueError,
        match="valid 'message' object",
    ):
        main.decode_pubsub_message({})


def test_decode_pubsub_message_rejects_invalid_base64():
    envelope = {
        "message": {
            "data": "not-valid-base64!!!",
            "messageId": "12345",
        }
    }

    with pytest.raises(
        ValueError,
        match="not valid base64-encoded JSON",
    ):
        main.decode_pubsub_message(envelope)


def test_health_endpoint_reports_bucket_configuration(
    client,
    monkeypatch,
):
    monkeypatch.setattr(main, "BUCKET_NAME", "test-bucket")

    response = client.get("/health")

    assert response.status_code == 200
    assert response.get_json() == {
        "status": "healthy",
        "bucket_configured": True,
    }


def test_valid_pubsub_message_is_written_to_gcs(
    client,
    monkeypatch,
):
    mock_storage_client = Mock()
    mock_bucket = Mock()
    mock_blob = Mock()

    mock_storage_client.bucket.return_value = mock_bucket
    mock_bucket.blob.return_value = mock_blob

    monkeypatch.setattr(main, "BUCKET_NAME", "test-bucket")
    monkeypatch.setattr(
        main,
        "get_storage_client",
        lambda: mock_storage_client,
    )
    monkeypatch.setattr(
        main,
        "build_object_name",
        lambda message_id: f"raw-events/{message_id}.json",
    )

    envelope = build_pubsub_envelope(
        payload={"order_id": "order-1002", "status": "created"},
        message_id="12345",
    )

    response = client.post("/", json=envelope)

    assert response.status_code == 204

    mock_storage_client.bucket.assert_called_once_with(
        "test-bucket"
    )
    mock_bucket.blob.assert_called_once_with(
        "raw-events/12345.json"
    )
    mock_blob.upload_from_string.assert_called_once()

    uploaded_json = (
        mock_blob.upload_from_string.call_args.args[0]
    )
    uploaded_event = json.loads(uploaded_json)

    assert uploaded_event["message_id"] == "12345"
    assert uploaded_event["payload"] == {
        "order_id": "order-1002",
        "status": "created",
    }
    assert uploaded_event["subscription"] == envelope["subscription"]

    assert (
        mock_blob.upload_from_string.call_args.kwargs[
            "content_type"
        ]
        == "application/json"
    )


def test_invalid_pubsub_payload_returns_204(
    client,
    monkeypatch,
):
    mock_write = Mock()

    monkeypatch.setattr(
        main,
        "write_event_to_gcs",
        mock_write,
    )

    envelope = {
        "message": {
            "data": "invalid-base64!",
            "messageId": "12345",
        }
    }

    response = client.post("/", json=envelope)

    assert response.status_code == 204
    mock_write.assert_not_called()


def test_storage_failure_returns_500(
    client,
    monkeypatch,
):
    monkeypatch.setattr(main, "BUCKET_NAME", "test-bucket")
    monkeypatch.setattr(
        main,
        "write_event_to_gcs",
        Mock(side_effect=RuntimeError("GCS unavailable")),
    )

    envelope = build_pubsub_envelope(
        payload={"order_id": "order-1002"},
    )

    response = client.post("/", json=envelope)

    assert response.status_code == 500
    assert response.get_json() == {
        "error": "Internal processing failure."
    }


def test_non_json_request_returns_400(client):
    response = client.post(
        "/",
        data="not-json",
        content_type="text/plain",
    )

    assert response.status_code == 400
    assert response.get_json() == {
        "error": "Request body must be valid JSON."
    }