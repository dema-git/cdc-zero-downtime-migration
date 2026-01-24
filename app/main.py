import asyncio
import random
from fastapi import FastAPI
from .kafka_consumer import start_consumer_loop, get_messages
from .services.manage_lagacy_data import manage_legacy_data_main
from app.db import SessionLocal
from app.logging_config import AppLogger
from app.services.fake_data_generator import generate_customers, generate_orders

app = FastAPI()
logger = AppLogger(component="auto_generator")


async def auto_generator():
    """
    Periodically generates random legacy customers and orders
    """
    while True:
        try:
            await asyncio.sleep(random.uniform(1, 4))
            db = SessionLocal()
            try:
                customers_count = random.randint(1, 2)
                customers = generate_customers(db, count=customers_count)
                orders_count = random.randint(2, 10)
                generate_orders(db, customers, count=orders_count)

                db.commit()

                logger.info(
                    "Generated legacy customers and orders",
                    customers_count=customers_count,
                    orders_count=orders_count,
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
    while True:
        await asyncio.sleep(poll_interval)

        batch = get_messages()
        if not batch:
            continue

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
