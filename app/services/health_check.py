####################################################################
# health_check.py
#
# Centralized health check utilities for the service.
# all checks into a structured payload suitable for HTTP endpoint (/health)
######################################################################

from typing import Any, Dict, List, Tuple
from confluent_kafka import Consumer, KafkaError, KafkaException, TopicPartition
from app.logging_config import AppLogger
from app.kafka_consumer import create_consumer, TOPICS
from app.db import LegacyDBSession, CleanDBSession
from typing import Any, Dict, Tuple, Callable
from sqlalchemy.orm import Session
from sqlalchemy import text

logger = AppLogger(component="health_check")

def check_kafka_health(required_topics: List[str] | None = None) -> Tuple[bool, Dict[str, Any]]:
    """
    Check Kafka broker availability and optionally verify required topics
    """
    consumer = None
    details: Dict[str, Any] = {}

    try:
        consumer = create_consumer()

        # Fetch cluster & topic metadata
        metadata = consumer.list_topics(timeout=5.0)
        details["broker"] = "ok"
        details["cluster_id"] = getattr(metadata, "cluster_id", None)

        if required_topics:
            existing_topics = set(metadata.topics.keys())
            missing = [t for t in required_topics if t not in existing_topics]

            details["existing_topics"] = list(existing_topics)
            details["required_topics"] = required_topics

            if missing:
                details["missing_topics"] = missing
                return False, details

        return True, details

    except KafkaException as e:
        logger.exception(
            "Kafka health check failed with KafkaException",
            error=str(e),
        )
        details["broker"] = "fail"
        details["error"] = str(e)
        return False, details

    except Exception as e:
        logger.exception(
            "Kafka health check failed with unexpected error",
            error=str(e),
        )
        details["broker"] = "fail"
        details["error"] = str(e)
        return False, details

    finally:
        if consumer is not None:
            try:
                consumer.close()
            except KafkaException as e:
                logger.error(
                    "Error while closing Kafka consumer in health check",
                    error=str(e),
                )


def check_db_health(session_factory: Callable[[], Session], label: str) -> Tuple[bool, Dict[str, Any]]:
    """
    Run a simple SELECT 1 to verify DB connectivity.
    """
    details: Dict[str, Any] = {
        "db_label": label,
    }

    try:
        db = session_factory()
        try:
            db.execute(text("SELECT 1"))
            details["status"] = "ok"
            return True, details
        finally:
            db.close()
    except Exception as exc:
        logger.exception(
            f"{label} health check failed",
            error=str(exc),
        )
        details["status"] = "fail"
        details["error"] = str(exc)
        return False, details


def health_check_main() -> Dict[str, Any]:
    """
    Aggregate Kafka + DB health checks into a single status payload
    """
    status: Dict[str, Any] = {}

    kafka_ok, kafka_details = check_kafka_health(required_topics=TOPICS)
    status["kafka"] = "ok" if kafka_ok else "fail"
    status["kafka_details"] = kafka_details

    legacy_ok, legacy_details = check_db_health(LegacyDBSession, "legacy_db")
    status["legacy_db"] = "ok" if legacy_ok else "fail"
    status["legacy_db_details"] = legacy_details

    clean_ok, clean_details = check_db_health(CleanDBSession, "clean_db")
    status["clean_db"] = "ok" if clean_ok else "fail"
    status["clean_db_details"] = clean_details

    core = [v for k, v in status.items() if not k.endswith("_details")]
    overall = "ok" if all(v == "ok" for v in core) else "degraded"

    return {"status": overall, "details": status}