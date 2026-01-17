
from sqlalchemy import ForeignKey, DateTime, func
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.db import Base
from dataclasses import dataclass
from typing import Any, Dict, Optional


##############################
# LEGACY DATABASE MODELS
##############################

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



##################
# DATACLASSES
##################

@dataclass
class Source:
    db: str
    schema: str
    table: str


@dataclass
class CDCEvent:
    key: Optional[Dict[str, Any]]
    before: Optional[Dict[str, Any]]
    after: Optional[Dict[str, Any]]
    source: Source
    operation: str

    @property
    def op_type(self) -> str:
        return self.operation

    @property
    def table_name(self) -> str:
        return self.source.table

    def get_insert_data(self) -> Optional[Dict[str, Any]]:
        if self.op_type == "c":
            return self.after
        return None

    def get_update_data(self) -> Optional[Dict[str, Any]]:
        if self.op_type == "u":
            return self.after
        return None

    def get_delete_data(self) -> Optional[Dict[str, Any]]:
        if self.op_type == "d":
            return self.before
        return None

    def has_before(self) -> bool:
        return self.before is not None


    def has_after(self) -> bool:
        return self.after is not None
