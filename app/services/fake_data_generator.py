###################################################
# fake_data_generator.py
#
# This module provides helper functions for generating fake data.
###################################################

import random
from faker import Faker
from sqlalchemy.orm import Session
from app.models import Customer, Order

fake = Faker()


# List of predefined warehouse locations.
# We assume these locations are fixed and do not change.
WAREHOUSES = [
    ("Berlin", "Germany"),
    ("Paris", "France"),
    ("Madrid", "Spain"),
    ("Rome", "Italy"),
    ("Amsterdam", "Netherlands"),
    ("Vienna", "Austria"),
    ("Prague", "Czech Republic"),
    ("Warsaw", "Poland"),
    ("Stockholm", "Sweden"),
    ("Helsinki", "Finland"),
]


def generate_customers(db: Session, count: int) -> list[Customer]:
    """
    Creates a specified number of fake customer records and saves them to the database.
    """
    customers = [
        Customer(
            full_name=fake.name(),
            email=fake.email(),
        )
        for _ in range(count)
    ]

    db.add_all(customers)
    db.commit()

    return customers


def generate_orders(db: Session,customers: list[Customer], count: int, ) -> None:
    """
    Generates random warehouse orders linked to existing customers and
    saves them to the database.
    Each order is assigned a random warehouse location and capacity.
    """
    orders = [
        Order(
            customer_id=random.choice(customers).id,
            warehouse_city=city,
            warehouse_country=country,
            capacity=random.randint(1, 100),
        )
        for city, country in (
            random.choice(WAREHOUSES) for _ in range(count)
        )
    ]

    db.add_all(orders)
    db.commit()