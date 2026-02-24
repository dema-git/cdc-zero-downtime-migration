#####################################################################
# tests/test_kafka_consumer_maybe_commit.py
#
# This test module verifies the logic of the internal _maybe_commit()
# helper used by kafka_consumer to decide when to call consumer.commit().
#
# It checks two main scenarios:
# - Commit SHOULD NOT happen when thresholds are not reached.
# - Commit SHOULD happen when message count exceeds the limit.
#
# The tests use MagicMock to simulate a Kafka consumer and inspect
# whether commit() was called under the correct conditions.
#####################################################################

import time
from unittest.mock import MagicMock
from app.kafka_consumer import _maybe_commit


def test_maybe_commit_no_trigger():
    consumer = MagicMock()

    # сonditions where commit SHOULD NOT happen
    messages_since_commit = 10
    last_commit_time = time.time()
    commit_every_messages = 50
    commit_every_seconds = 5

    # сall the function
    new_count, new_time = _maybe_commit(
        consumer,
        messages_since_commit,
        last_commit_time,
        commit_every_messages,
        commit_every_seconds,
    )

    # expect: commit was NOT called
    consumer.commit.assert_not_called()

    # counters should remain unchanged
    assert new_count == messages_since_commit
    assert new_time == last_commit_time


def test_maybe_commit_by_message_count():
    consumer = MagicMock()

    # conditions where commit SHOULD happen due to message threshold
    messages_since_commit = 51
    last_commit_time = time.time() - 1
    commit_every_messages = 50
    commit_every_seconds = 5

    # call the function
    new_count, new_time = _maybe_commit(
        consumer,
        messages_since_commit,
        last_commit_time,
        commit_every_messages,
        commit_every_seconds,
    )

    # expect: commit was called exactly once
    consumer.commit.assert_called_once()

    # after commit: counter must be reset
    assert new_count == 0

    # timestamp should be updated
    assert new_time > last_commit_time