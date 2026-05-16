from unittest.mock import MagicMock

from app.services import health_check


def test_check_db_returns_ok_when_select_succeeds():
    # A successful SELECT 1 means the database connection is healthy.
    session = MagicMock()
    session_factory = MagicMock(return_value=session)

    assert health_check.check_db(session_factory) == "ok"
    session.execute.assert_called_once()
    session.close.assert_called_once()


def test_check_db_returns_fail_and_closes_session_on_error():
    # Even on errors, the session must be closed.
    session = MagicMock()
    session.execute.side_effect = RuntimeError("db is down")
    session_factory = MagicMock(return_value=session)

    assert health_check.check_db(session_factory) == "fail"
    session.close.assert_called_once()


def test_health_check_main_aggregates_component_statuses(monkeypatch):
    # The top-level health status is degraded if any component fails.
    monkeypatch.setattr(health_check, "TOPICS", ["topic-a"])
    monkeypatch.setattr(health_check, "KAFKA_SINK_CONNECTOR", "sink")
    monkeypatch.setattr(health_check, "KAFKA_SOURCE_CONNECTOR", "source")
    monkeypatch.setattr(health_check, "check_kafka", MagicMock(return_value="ok"))
    monkeypatch.setattr(health_check, "check_db", MagicMock(side_effect=["ok", "fail"]))
    monkeypatch.setattr(health_check, "check_connector", MagicMock(side_effect=["ok", "ok"]))

    assert health_check.health_check_main() == {
        "status": "degraded",
        "kafka": "ok",
        "legacy_db": "ok",
        "clean_db": "fail",
        "kafka_sink": "ok",
        "kafka_source": "ok",
    }
