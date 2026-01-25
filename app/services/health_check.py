###################################################################
#
# health_check.py
#
# Centralized health check utilities for the service.
# Aggregates all checks into a structured payload suitable
# for HTTP endpoint (/health)
# #################################################################

from typing import Dict, Any, List, Tuple
import json
import urllib.request
import urllib.error

from confluent_kafka import KafkaException
from sqlalchemy.orm import Session
from sqlalchemy import text

from app.logging_config import AppLogger
from app.kafka_consumer import create_consumer, TOPICS
from app.db import LegacyDBSession, CleanDBSession

logger = AppLogger(component="health_check")

KAFKA_CONNECT_URL = "http://connect:8083"
KAFKA_SINK_CONNECTOR = "postgres_clean_sink"
KAFKA_SOURCE_CONNECTOR = "my_postgres_connector"


def http_get_json(url: str, timeout: int = 5) -> Dict[str, Any]:
    try:
        with urllib.request.urlopen(url, timeout=timeout) as resp:
            return json.loads(resp.read().decode("utf-8"))
    except urllib.error.HTTPError as e:
        raise Exception(f"HTTP {e.code}: {e.reason}")
    except urllib.error.URLError as e:
        raise Exception(f"URL error: {e.reason}")


def check_kafka(required_topics: List[str]) -> str:
    """
    Verify Kafka broker availability and ensure required topics exist.
    Returns "ok" or "fail"
    """
    consumer = None
    try:
        consumer = create_consumer()
        metadata = consumer.list_topics(timeout=5.0)

        existing = set(metadata.topics.keys())
        missing = [t for t in required_topics if t not in existing]

        if missing:
            return "fail"

        return "ok"

    except Exception as e:
        logger.exception("Kafka health failed", error=str(e))
        return "fail"

    finally:
        if consumer:
            try:
                consumer.close()
            except KafkaException:
                pass


def check_db(session_factory) -> str:
    """
    Execute a basic SELECT 1 to confirm database connectivity.
    Returns "ok" or "fail"
    """
    try:
        db = session_factory()
        try:
            db.execute(text("SELECT 1"))
            return "ok"
        finally:
            db.close()
    except Exception as e:
        logger.exception("DB health failed", error=str(e))
        return "fail"


def check_connector(name: str) -> str:
    """
    Check Kafka Connect connector status through its REST endpoint
    """
    try:
        url = f"{KAFKA_CONNECT_URL}/connectors/{name}/status"
        data = http_get_json(url)

        connector_state = data.get("connector", {}).get("state")
        task_states = {t.get("state") for t in data.get("tasks", [])}

        if connector_state == "RUNNING" and task_states == {"RUNNING"}:
            return "ok"
        return "fail"

    except Exception as e:
        logger.exception("Connector health failed", connector=name, error=str(e))
        return "fail"


def health_check_main() -> Dict[str, Any]:
    """
    Aggregate all component health checks into a single status payload
    """
    kafka = check_kafka(TOPICS)
    legacy_db = check_db(LegacyDBSession)
    clean_db = check_db(CleanDBSession)
    kafka_sink = check_connector(KAFKA_SINK_CONNECTOR)
    kafka_source = check_connector(KAFKA_SOURCE_CONNECTOR)

    all_ok = all([
        kafka == "ok",
        legacy_db == "ok",
        clean_db == "ok",
        kafka_sink == "ok",
        kafka_source == "ok",
    ])

    return {
        "status": "ok" if all_ok else "degraded",
        "kafka": kafka,
        "legacy_db": legacy_db,
        "clean_db": clean_db,
        "kafka_sink": kafka_sink,
        "kafka_source": kafka_source,
    }