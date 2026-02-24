#####################################################################
# tests/test_kafka_consumer_config.py
#
# This test module checks how kafka_consumer loads and validates
# its configuration from environment variables.
#
# It verifies that:
# - Missing KAFKA_BROKERCONNECT triggers a clear RuntimeError
# - Missing GROUP_ID triggers a clear RuntimeError
# - Missing or empty topic list also triggers a RuntimeError
#
# The module uses a helper function to reset environment variables
# and reload the kafka_consumer module so each test starts clean.
#####################################################################

import importlib
import pytest
import os

MODULE_PATH = "app.kafka_consumer"


def reload_kafka_consumer(monkeypatch, **env_overrides):
    """
    Helper function:
    - Clears relevant environment variables
    - Applies overrides for the current test
    - Reloads the kafka_consumer module so that env vars are re-read
    """

    # remove env vars that affect consumer configuration
    for key in [
        "KAFKA_BROKERCONNECT",
        "GROUP_ID",
        "TOPICS_LEGACY_ORDERS",
        "TOPICS_LEGACY_CUSTOMERS",
    ]:
        monkeypatch.delenv(key, raising=False)

    # define environment overrides for the test
    for key, value in env_overrides.items():
        monkeypatch.setenv(key, value)

    # reload the module to re-evaluate env-based config
    import app.kafka_consumer as kafka_consumer

    importlib.reload(kafka_consumer)
    return kafka_consumer


def test_create_consumer_fails_without_bootstrap(monkeypatch):
    """
    Test: create_consumer() must fail if KAFKA_BROKERCONNECT is missing.
    It should raise RuntimeError with a clear error message
    """
    kafka_consumer = reload_kafka_consumer(
        monkeypatch,
        # NOT setting KAFKA_BROKERCONNECT
        GROUP_ID="test-group",
        TOPICS_LEGACY_ORDERS="legacy.orders",
        TOPICS_LEGACY_CUSTOMERS="legacy.customers",
    )

    with pytest.raises(RuntimeError) as exc_info:
        kafka_consumer.create_consumer()

    assert "KAFKA_BROKERCONNECT is not configured" in str(exc_info.value)


def test_create_consumer_fails_without_group_id(monkeypatch):
    """
    Test: create_consumer() must fail if GROUP_ID is missing
    """
    kafka_consumer = reload_kafka_consumer(
        monkeypatch,
        KAFKA_BROKERCONNECT="kafka:9092",
        # GROUP_ID intentionally omitted
        TOPICS_LEGACY_ORDERS="legacy.orders",
        TOPICS_LEGACY_CUSTOMERS="legacy.customers",
    )

    # expect RuntimeError due to missing group id
    with pytest.raises(RuntimeError) as exc_info:
        kafka_consumer.create_consumer()

    assert "GROUP_ID is not configured" in str(exc_info.value)


def test_create_consumer_fails_without_topics(monkeypatch):
    """
    Test: create_consumer() must fail if no topics are configured.
    """
    kafka_consumer = reload_kafka_consumer(
        monkeypatch,
        KAFKA_BROKERCONNECT="kafka:9092",
        GROUP_ID="test-group",
        # no topics provided
    )

    # expect RuntimeError because topic list is empty
    with pytest.raises(RuntimeError) as exc_info:
        kafka_consumer.create_consumer()

    assert "No topics configured" in str(exc_info.value)