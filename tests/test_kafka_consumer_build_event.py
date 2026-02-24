###########################################################
# tests/test_kafka_consumer_build_event.py
#
# This test checks the build_cdc_event() function.
# It verifies that a raw CDC message from Kafka
# is correctly transformed into a structured CDCEvent object
###########################################################

from app.kafka_consumer import build_cdc_event


def test_build_cdc_event_basic():
    raw = {
        "key": b'{"id": 123}',
        "data": {
            "schema": {"type": "struct"},
            "payload": {"id": 123, "name": "Test"},
        },
        "topic": "legacy.orders",
        "partition": 0,
        "offset": 10,
    }

    # build CDCEvent object from raw message
    event = build_cdc_event(raw)

    # assert that the key was decoded correctly
    assert event.key == {"id": 123}

    # assert schema is extracted properly
    assert event.schema == {"type": "struct"}

    # assert payload is extracted properly
    assert event.payload == {"id": 123, "name": "Test"}