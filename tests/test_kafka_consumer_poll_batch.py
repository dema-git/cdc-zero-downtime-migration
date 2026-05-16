###########################################################
# tests/test_kafka_consumer_poll_batch.py
#
# These tests check how raw Kafka messages are polled and converted
# into CDCEvent objects before transformation.
###########################################################

from unittest.mock import MagicMock

from app import kafka_consumer
from app.models import CDCEvent


def make_message(value=b'{"schema": {"type": "struct"}, "payload": {"id": 1}}'):
    # Build a fake Kafka message with the methods used by the consumer.
    msg = MagicMock()
    msg.error.return_value = None
    msg.key.return_value = b'{"id": 1}'
    msg.value.return_value = value
    msg.topic.return_value = "cdc.public.legacy_orders"
    msg.partition.return_value = 0
    msg.offset.return_value = 10
    return msg


def test_poll_batch_returns_events_with_kafka_metadata():
    # The consumer returns one message and then stops the batch.
    consumer = MagicMock()
    consumer.poll.side_effect = [make_message(), None]

    # Poll one batch from the fake Kafka consumer.
    events = kafka_consumer._poll_batch(consumer, max_messages=50, poll_timeout=0)

    # The raw message is converted to CDCEvent and keeps Kafka metadata.
    assert len(events) == 1
    assert isinstance(events[0], CDCEvent)
    assert events[0].payload == {"id": 1}
    assert events[0].topic == "cdc.public.legacy_orders"
    assert events[0].partition == 0
    assert events[0].offset == 10


def test_poll_batch_skips_invalid_json_message():
    # The consumer returns a message with invalid JSON payload.
    consumer = MagicMock()
    consumer.poll.side_effect = [make_message(value=b"{not-json"), None]

    # Polling should skip the invalid message instead of returning a bad event.
    events = kafka_consumer._poll_batch(consumer, max_messages=50, poll_timeout=0)

    assert events == []
