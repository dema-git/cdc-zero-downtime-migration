#####################################################################
# tests/test_kafka_consumer_get_messages.py
#
# This test module verifies the behavior of get_messages() in the
# kafka_consumer module.
#
# Purpose:
# - Ensure that raw messages in the internal message_queue are
#   correctly converted into CDCEvent objects.
# - Confirm that the queue is fully cleared after retrieval.
# - Validate that events preserve correct payload data.
#
# The test manually fills the queue, calls get_messages(), and checks
# both returned objects and the cleanup behavior.
#####################################################################

import importlib
from app import kafka_consumer
from app.models import CDCEvent


def test_get_messages_returns_events_and_clears_queue():
    # prepare: manually fill message_queue with sample raw messages
    sample_messages = [
        {
            "key": b'{"id": 1}',
            "data": {"schema": {"type": "struct"}, "payload": {"id": 1}},
            "topic": "legacy.orders",
            "partition": 0,
            "offset": 10,
        },
        {
            "key": b'{"id": 2}',
            "data": {"schema": {"type": "struct"}, "payload": {"id": 2}},
            "topic": "legacy.orders",
            "partition": 0,
            "offset": 11,
        },
    ]

    # reload the module to reset any previous internal state
    importlib.reload(kafka_consumer)

    # manually populate the internal queue
    with kafka_consumer.queue_lock:
        kafka_consumer.message_queue.extend(sample_messages)

    # call the function
    events = kafka_consumer.get_messages()

    # assertions: two events must be returned
    assert len(events) == 2
    assert all(isinstance(e, CDCEvent) for e in events)

    # the queue must be fully cleared after reading
    assert kafka_consumer.message_queue == []

    # validate returned event data
    assert events[0].payload["id"] == 1
    assert events[1].payload["id"] == 2