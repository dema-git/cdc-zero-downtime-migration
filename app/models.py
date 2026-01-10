# from sqlalchemy import (
#     create_engine, Column, Integer, String, DECIMAL, TIMESTAMP, ForeignKey, func
# )
# from sqlalchemy.orm import declarative_base, relationship
#
# Base = declarative_base()
#
# class User(Base):
#     __tablename__ = "users"
#
#     id = Column(Integer, primary_key=True)
#     name = Column(String(255), nullable=False)
#     email = Column(String(255), unique=True, nullable=False)
#     created_at = Column(TIMESTAMP, server_default=func.now())
#
#     orders = relationship("Order", back_populates="user")
#
#
# class Order(Base):
#     __tablename__ = "orders"
#
#     id = Column(Integer, primary_key=True)
#     user_id = Column(Integer, ForeignKey("users.id"))
#     amount = Column(DECIMAL(10,2), nullable=False)
#     created_at = Column(TIMESTAMP, server_default=func.now())
#
#     user = relationship("User", back_populates="orders")

from sqlalchemy import ForeignKey, DateTime, func
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.db import Base


class Customer(Base):
    __tablename__ = "legacy_customers"
    __table_args__ = {"extend_existing": True}

    id: Mapped[int] = mapped_column(primary_key=True)
    full_name: Mapped[str]
    email: Mapped[str | None]

    created_at: Mapped["DateTime"] = mapped_column(
        DateTime,
        server_default=func.now(),
    )

    orders: Mapped[list["Order"]] = relationship(
        back_populates="customer",
        lazy="selectin",
    )


class Order(Base):
    __tablename__ = "legacy_orders"
    __table_args__ = {"extend_existing": True}

    id: Mapped[int] = mapped_column(primary_key=True)
    customer_id: Mapped[int] = mapped_column(
        ForeignKey("legacy_customers.id"),
        nullable=False,
    )

    warehouse_city: Mapped[str]
    warehouse_country: Mapped[str]

    capacity: Mapped[int]

    created_at: Mapped["DateTime"] = mapped_column(
        DateTime,
        server_default=func.now(),
    )

    customer: Mapped["Customer"] = relationship(back_populates="orders")
