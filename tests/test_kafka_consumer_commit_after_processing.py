###########################################################
# tests/test_kafka_consumer_commit_after_processing.py
#
# These tests check the most important CDC guarantee:
# Kafka offsets must be committed only after a batch is processed.
###########################################################

from unittest.mock import MagicMock

from app import kafka_consumer
from app.models import CDCEvent


def test_process_polled_batch_commits_after_successful_processing(monkeypatch):
    # Prepare one polled CDC event and a successful processing callback.
    consumer = MagicMock()
    process_batch = MagicMock()
    event = CDCEvent(schema={}, payload={"op": "c"}, topic="cdc.topic", partition=0, offset=10)

    monkeypatch.setattr(kafka_consumer, "_poll_batch", MagicMock(return_value=[event]))

    # Process the batch.
    processed = kafka_consumer._process_polled_batch(consumer, process_batch)

    # The offset is committed only after the processing callback succeeds.
    assert processed is True
    process_batch.assert_called_once_with([event])
    consumer.commit.assert_called_once_with(asynchronous=False)


def test_process_polled_batch_does_not_commit_when_processing_fails(monkeypatch):
    # Prepare one polled CDC event and a failing processing callback.
    consumer = MagicMock()
    process_batch = MagicMock(side_effect=RuntimeError("transform failed"))
    event = CDCEvent(schema={}, payload={"op": "c"}, topic="cdc.topic", partition=0, offset=10)

    monkeypatch.setattr(kafka_consumer, "_poll_batch", MagicMock(return_value=[event]))

    # Process the batch.
    processed = kafka_consumer._process_polled_batch(consumer, process_batch)

    # Failed processing must not commit Kafka offsets.
    assert processed is False
    process_batch.assert_called_once_with([event])
    consumer.commit.assert_not_called()


def test_process_polled_batch_does_nothing_without_messages(monkeypatch):
    # Prepare an empty poll result.
    consumer = MagicMock()
    process_batch = MagicMock()

    monkeypatch.setattr(kafka_consumer, "_poll_batch", MagicMock(return_value=[]))

    # Try to process an empty batch.
    processed = kafka_consumer._process_polled_batch(consumer, process_batch)

    # No messages means no processing and no offset commit.
    assert processed is None
    process_batch.assert_not_called()
    consumer.commit.assert_not_called()
