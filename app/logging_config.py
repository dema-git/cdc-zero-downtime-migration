###########################################################
# logging_config.py
#
# Application-wide logging setup and structured logging helper
#
# This module initializes the root logger once and provides the "AppLogger"
# dataclass for consistent JSON-formatted logs
#
##############################################################

import logging
import json
import uuid
from dataclasses import dataclass, field
from logging.handlers import RotatingFileHandler


def setup_root_logger() -> logging.Logger:
    logger = logging.getLogger("app")
    logger.setLevel(logging.DEBUG)

    if logger.handlers:
        return logger

    console = logging.StreamHandler()
    console.setLevel(logging.INFO)

    formatter = logging.Formatter(
        "%(asctime)s %(levelname)s %(name)s: %(message)s"
    )
    console.setFormatter(formatter)
    logger.addHandler(console)

    # automatically rotates the file when it reaches 10 MB,
    # keeping up to 5 backups
    file_handler = RotatingFileHandler(
        "/logs/app.log",
        maxBytes=10_000_000,
        backupCount=10,
    )

    file_handler.setLevel(logging.INFO)
    file_handler.setFormatter(formatter)
    logger.addHandler(file_handler)

    return logger

ROOT_LOGGER = setup_root_logger()


@dataclass
class AppLogger:
    component: str
    logger: logging.Logger = field(
        default_factory=lambda: logging.getLogger("app")
    )

    def _log(self, level: str, message: str, **fields):
        trace_id = fields.pop("trace_id", str(uuid.uuid4()))
        payload = {
            "trace_id": trace_id,
            "component": self.component,
            "msg": message,
            **fields,
        }
        text = json.dumps(payload, ensure_ascii=False)
        log_fn = getattr(self.logger, level, self.logger.info)
        log_fn(text)

    # logging levels
    def info(self, message: str, **fields):
        self._log("info", message, **fields)

    def debug(self, message: str, **fields):
        self._log("debug", message, **fields)

    def error(self, message: str, **fields):
        self._log("error", message, **fields)

    def exception(self, message: str, **fields):
        self._log("exception", message, **fields)