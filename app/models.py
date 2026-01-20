
from sqlalchemy import ForeignKey, DateTime, func
from sqlalchemy.orm import Mapped, mapped_column, relationship
from app.db import Base
from dataclasses import dataclass
from typing import Any, Dict, Optional, Tuple, List


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

JsonDict = Dict[str, Any]

@dataclass(frozen=True)
class Source:
    db: str
    schema: str
    table: str


@dataclass
class CDCEvent:
    schema: JsonDict
    payload: JsonDict
    key: Optional[JsonDict] = None


    @property
    def op(self) -> str:
        return self.payload.get("op", "")


    @property
    def op_type(self) -> str:
        return self.op


    @property
    def source(self) -> Source:
        s = self.payload.get("source") or {}
        return Source(
            db=s.get("db", ""),
            schema=s.get("schema", ""),
            table=s.get("table", ""),
        )


    @property
    def table_name(self) -> str:
        return self.source.table


    def data(self) -> Optional[JsonDict]:
        if self.op_type in ("c", "u", "r"):
            return self.payload.get("after")
        if self.op_type == "d":
            return self.payload.get("before")
        return None


    @staticmethod
    def _split_full_name(full_name: str) -> Tuple[str, str]:
        parts = full_name.strip().split()
        if not parts:
            return "", ""
        if len(parts) == 1:
            return parts[0], ""
        return parts[0], parts[-1]


    @staticmethod
    def _patch_struct_fields(struct_fields: List[JsonDict]) -> None:

        struct_fields[:] = [f for f in struct_fields if f.get("field") != "full_name"]

        existing = {f.get("field") for f in struct_fields}
        if "first_name" not in existing:
            struct_fields.append({"type": "string", "optional": True, "field": "first_name"})
        if "last_name" not in existing:
            struct_fields.append({"type": "string", "optional": True, "field": "last_name"})


    def _patch_envelope_schema(self) -> None:

        schema_fields = self.schema.get("fields", [])
        for top_field in schema_fields:
            if top_field.get("field") in ("before", "after") and top_field.get("type") == "struct":
                struct_fields = top_field.get("fields", [])
                if isinstance(struct_fields, list):
                    self._patch_struct_fields(struct_fields)


    def split_full_name(self) -> bool:

        row = self.data()
        if not row or "full_name" not in row:
            return False

        full = row.get("full_name") or ""
        first, last = self._split_full_name(full)

        row.pop("full_name", None)
        row["first_name"] = first
        row["last_name"] = last

        self._patch_envelope_schema()
        return True


    def to_message(self) -> JsonDict:
        return {"schema": self.schema, "payload": self.payload}

################
# legacy_orders: warehouse_* → warehouse_id
################

    @staticmethod
    def _patch_legacy_orders_struct_fields(struct_fields: list[JsonDict]) -> None:
        for f in struct_fields:
            field_name = f.get("field")

            if field_name in ("warehouse_country",):
                f["__drop__"] = True
                continue

            if field_name == "warehouse_city":
                f["field"] = "warehouse_id"
                f["type"] = "int64"

        struct_fields[:] = [f for f in struct_fields if not f.get("__drop__")]


    def _patch_legacy_orders_envelope_schema(self) -> None:

        schema_fields = self.schema.get("fields", [])
        for top_field in schema_fields:

            if top_field.get("field") in ("before", "after") and top_field.get("type") == "struct":
                struct_fields = top_field.get("fields", [])
                if isinstance(struct_fields, list):
                    self._patch_legacy_orders_struct_fields(struct_fields)


    def normalize_warehouse(self, city_to_id: dict[str, int]) -> bool:
        row = self.data()
        if not row:
            return False

        city = row.get("warehouse_city")
        if not city:
            return False

        city_id = city_to_id.get(city)
        if city_id is None:
            return False

        row["warehouse_id"] = city_id

        row.pop("warehouse_city", None)
        row.pop("warehouse_country", None)

        self._patch_legacy_orders_envelope_schema()
        return True