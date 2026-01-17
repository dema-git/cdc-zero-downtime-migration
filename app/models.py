
from sqlalchemy import ForeignKey, DateTime, func
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.db import Base
from dataclasses import dataclass
from typing import Any, Dict, Optional
import numpy as np

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
    op: str

    @property
    def op_type(self) -> str:
        return self.op

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

    def get_data(self) -> Optional[Dict[str, Any]]:
        if self.op_type == "c":
            return self.after
        if self.op_type == "u":
            return self.after
        if self.op_type == "d":
            return self.before
        return None

    def with_split_name(self) -> Optional[Dict[str, Any]]:

        data = self.get_data()
        if not data:
            return None

        full_name = data.pop("full_name", "")

        name_array = np.array(full_name.strip().split())
        first_name = name_array[0] if name_array.size > 0 else ""
        last_name = name_array[-1] if name_array.size > 1 else ""

        new_data = data.copy()
        new_data["first_name"] = first_name
        new_data["last_name"] = last_name

        return {
            "key": self.key,
            "data": new_data,
            "source": {
                "db": self.source.db,
                "schema": self.source.schema,
                "table": self.source.table
            },
            "op": self.op,
        }