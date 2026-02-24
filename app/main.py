###################################################################################################
# main.py (FastAPI application)
#
# This module initializes the FastAPI service responsible for:
#
# 1. Running background workers:
#       * auto_generator — periodically generates synthetic legacy data
#         (customers + orders) and writes it into the legacy PostgreSQL database.
#
#       * cdc_worker — periodically retrieves CDC events consumed from Kafka
#         (via kafka_consumer.get_messages) and forwards them to the transformation
#         pipeline (manage_legacy_data_main), which normalizes the data and
#         republishes it into the cleared_* Kafka topics.
#
# 2. Starting the Kafka CDC consumer loop in a dedicated background thread on app startup.
#
# 3. Exposing API endpoints:
#       • /cdc/events — manually trigger processing of buffered CDC events.
#       • /health     — full system health-check (Kafka, connectors, DBs).
#
# Overall, this module coordinates event generation, CDC consumption,
# transformation, and routing of messages between legacy DB, Kafka, and the
# cleaned data pipeline, all wrapped inside a FastAPI application.
###################################################################################################

import asyncio
import random
from fastapi import FastAPI
from .kafka_consumer import start_consumer_loop, get_messages
from .services.manage_lagacy_data import manage_legacy_data_main
from .db import LegacyDBSession, CleanDBSession
from .logging_config import AppLogger
from .services.fake_data_generator import generate_customers, generate_orders
from typing import Any, Dict
from .services.health_check import health_check_main

app = FastAPI()
logger = AppLogger(component="auto_generator")


async def auto_generator():
    """
    Periodically generates random legacy customers and orders
    """
    while True:
        try:
            await asyncio.sleep(random.uniform(1, 4))
            db = LegacyDBSession()
            try:
                customers_count = random.randint(1, 2)
                customers = generate_customers(db, count=customers_count)
                orders_count = random.randint(2, 10)
                generate_orders(db, customers, count=orders_count)

                db.commit()

                logger.info(
                     "Generated legacy customers and orders in legacy DB",
                    customers_count=customers_count,
                    orders_count=orders_count,
                    pipeline_stage="generate_legacy_data",
                )

            finally:
                db.close()

        except Exception as exc:
            logger.exception(
                "auto_generator crashed with exception",
                error=str(exc),
            )
            await asyncio.sleep(5)



async def cdc_worker(poll_interval: float = 5.0):
    """
    Periodically fetches and processes CDC events from Kafka
    """
    worker_log = AppLogger(component="cdc_worker")

    while True:
        await asyncio.sleep(poll_interval)

        batch = get_messages()
        if not batch:
            continue

        worker_log.info(
            "Dispatching CDC batch to legacy transformer",
            batch_size=len(batch),
            pipeline_stage="cdc_worker_dispatch",
        )

        manage_legacy_data_main(batch)


@app.on_event("startup")
async def startup_event():
    """
     Initializes Kafka consumer and starts background workers on app startup
    """
    start_consumer_loop()
    asyncio.create_task(auto_generator())
    asyncio.create_task(cdc_worker(poll_interval=5.0))


@app.get("/cdc/events")
def cdc_events():
    """
    API endpoint to manually trigger processing of pending CDC events
    """
    batch = get_messages()
    manage_legacy_data_main(batch)
    return {"count": len(batch), "events": batch}


@app.get("/health")
def health() -> Dict[str, Any]:
    """
    Health-check endpoint that verifies:
    * Kafka (broker + CDC topics)
    * legacy database connectivity
    * clean database connectivity
    * Kafka Connect source and sink connectors
    """
    return health_check_main()