import asyncio
import random
import logging

from fastapi import FastAPI
from .kafka_consumer import start_consumer_loop, get_messages
from .services.manage_lagacy_data import manage_legacy_data_main

from app.db import SessionLocal
from app.services.fake_data_generator import generate_customers, generate_orders

app = FastAPI()

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)


async def auto_generator():
    while True:
        await asyncio.sleep(random.uniform(1, 4))
        db = SessionLocal()
        try:
            customers_count = random.randint(1, 2)
            customers = generate_customers(db, count=customers_count)
            orders_count = random.randint(2, 10)
            generate_orders(db, customers, count=orders_count)

            db.commit()
        finally:
            db.close()

        logger.info(f"Legacy orders generated: {len(customers)} customers, {orders_count} orders")


@app.on_event("startup")
async def startup_event():
    start_consumer_loop()
    asyncio.create_task(auto_generator())



@app.get("/cdc/events")
def cdc_events():
    batch = get_messages()
    # manage_legacy_data_main(batch)
    return {"count": len(batch), "events": batch}
