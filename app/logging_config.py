###########################################################
# logging_config.py
#
# Application-wide logging setup and structured logging helper
# This module initializes the root logger once and provides the "AppLogger"
# dataclass for consistent JSON-formatted logs
#
# ###########################################################

import logging
import json
import uuid
from dataclasses import dataclass, field
from logging.handlers import RotatingFileHandler
from datetime import datetime


class JSONFormatter(logging.Formatter):
    """
    SON Formatter — converts every log record into clean JSON
    """
    def format(self, record):
        base = {
            "timestamp": datetime.utcfromtimestamp(record.created).isoformat() + "Z",
            "level": record.levelname,
            "logger": record.name,
        }

        try:
            payload = json.loads(record.getMessage())
        except json.JSONDecodeError:
            payload = {"msg": record.getMessage()}

        return json.dumps({**base, **payload}, ensure_ascii=False)


def setup_root_logger() -> logging.Logger:
    """
    Root logger initialization
    """
    logger = logging.getLogger("app")
    logger.setLevel(logging.DEBUG)

    if logger.handlers:
        return logger  # Prevent duplicate

    json_formatter = JSONFormatter()

    # Console JSON logging
    console = logging.StreamHandler()
    console.setLevel(logging.INFO)
    console.setFormatter(json_formatter)
    logger.addHandler(console)

    # Rotating file handler
    file_handler = RotatingFileHandler(
        "/logs/app.log",
        maxBytes=10_000_000,   # 10 MB
        backupCount=10,        # keep 10 backups
        encoding="utf-8",
    )
    file_handler.setLevel(logging.INFO)
    file_handler.setFormatter(json_formatter)
    logger.addHandler(file_handler)

    return logger


ROOT_LOGGER = setup_root_logger()


#####################
# AppLogger
#####################

@dataclass
class AppLogger:
    component: str
    logger: logging.Logger = field(
        default_factory=lambda: logging.getLogger("app")
    )

    def _log(self, level: str, message: str, exc_info=False, **fields):
        trace_id = fields.pop("trace_id", str(uuid.uuid4()))

        payload = {
            "trace_id": trace_id,
            "component": self.component,
            "msg": message,
            **fields,
        }

        text = json.dumps(payload, ensure_ascii=False)

        log_fn = getattr(self.logger, level, self.logger.info)
        log_fn(text, exc_info=exc_info)

    # Logging levels
    def info(self, message: str, **fields):
        self._log("info", message, **fields)

    def debug(self, message: str, **fields):
        self._log("debug", message, **fields)

    def error(self, message: str, **fields):
        self._log("error", message, **fields)

    def exception(self, message: str, **fields):
        self._log("error", message, exc_info=True, **fields)