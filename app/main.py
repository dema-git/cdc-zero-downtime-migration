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