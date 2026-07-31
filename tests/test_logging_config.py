import json
import logging

from app.logging_config import JsonFormatter


def test_json_formatter_outputs_structured_log() -> None:
    formatter = JsonFormatter()

    record = logging.LogRecord(
        name="app.main",
        level=logging.INFO,
        pathname=__file__,
        lineno=10,
        msg="Event uploaded successfully.",
        args=(),
        exc_info=None,
    )

    record.message_id = "message-123"
    record.event = "event_uploaded"

    formatted = formatter.format(record)
    parsed = json.loads(formatted)

    assert parsed["severity"] == "INFO"
    assert parsed["message"] == "Event uploaded successfully."
    assert parsed["logger"] == "app.main"
    assert parsed["message_id"] == "message-123"
    assert parsed["event"] == "event_uploaded"
    assert "timestamp" in parsed