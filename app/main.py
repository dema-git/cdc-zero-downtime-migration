###################################################################################################
# main.py (FastAPI application)
#
# This module initializes the FastAPI service responsible for:
#
# 1. Running background workers:
#       * auto_generator — periodically generates synthetic legacy data
#         (customers + orders) and writes it into the legacy PostgreSQL database.
#
#       * cdc_worker — consumes CDC events from Kafka, forwards them to the
#         transformation pipeline, and commits offsets only after successful
#         processing.
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
from .kafka_consumer import start_consumer_loop
from .services.manage_lagacy_data import manage_legacy_data_main
from .db import LegacyDBSession
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



@app.on_event("startup")
async def startup_event():
    """
     Initializes Kafka consumer and starts background workers on app startup
    """
    start_consumer_loop(process_batch=manage_legacy_data_main)
    asyncio.create_task(auto_generator())


@app.get("/cdc/events")
def cdc_events():
    """
    API endpoint with CDC worker status.
    """
    return {"status": "cdc_worker_running"}


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
