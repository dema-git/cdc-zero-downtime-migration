from copy import deepcopy

from app.models import CDCEvent


def envelope_schema(*fields):
    return {
        "fields": [
            {
                "field": "before",
                "type": "struct",
                "fields": [dict(field) for field in fields],
            },
            {
                "field": "after",
                "type": "struct",
                "fields": [dict(field) for field in fields],
            },
        ]
    }


def customer_event(full_name="Ada Lovelace"):
    return CDCEvent(
        key={"id": 1},
        schema=envelope_schema(
            {"field": "id", "type": "int64"},
            {"field": "full_name", "type": "string"},
            {"field": "email", "type": "string"},
        ),
        payload={
            "op": "c",
            "source": {"db": "legacy", "schema": "public", "table": "legacy_customers"},
            "after": {"id": 1, "full_name": full_name, "email": "ada@example.com"},
        },
    )


def order_event(city="Berlin"):
    return CDCEvent(
        key={"id": 10},
        schema=envelope_schema(
            {"field": "id", "type": "int64"},
            {"field": "warehouse_city", "type": "string"},
            {"field": "warehouse_country", "type": "string"},
            {"field": "capacity", "type": "int64"},
        ),
        payload={
            "op": "u",
            "source": {"db": "legacy", "schema": "public", "table": "legacy_orders"},
            "after": {
                "id": 10,
                "warehouse_city": city,
                "warehouse_country": "Germany",
                "capacity": 42,
            },
        },
    )


def test_split_full_name_updates_payload_and_schema():
    # Full name is split into first_name and last_name for the clean schema.
    event = customer_event("Grace Hopper")

    changed = event.split_full_name()

    assert changed is True
    assert event.payload["after"] == {
        "id": 1,
        "email": "ada@example.com",
        "first_name": "Grace",
        "last_name": "Hopper",
    }

    # The schema must match the transformed payload.
    for field in event.schema["fields"]:
        nested_names = {nested["field"] for nested in field["fields"]}
        assert "full_name" not in nested_names
        assert {"first_name", "last_name"}.issubset(nested_names)


def test_split_full_name_returns_false_when_field_is_missing():
    # Missing legacy field should leave the event unchanged.
    event = customer_event()
    event.payload["after"].pop("full_name")
    original_schema = deepcopy(event.schema)

    assert event.split_full_name() is False
    assert event.schema == original_schema


def test_normalize_warehouse_updates_payload_and_schema():
    # Warehouse city/country are normalized to warehouse_id.
    event = order_event("Paris")

    changed = event.normalize_warehouse({"Paris": 2})

    assert changed is True
    assert event.payload["after"] == {
        "id": 10,
        "capacity": 42,
        "warehouse_id": 2,
    }

    # The schema must expose warehouse_id and drop legacy warehouse fields.
    for field in event.schema["fields"]:
        nested = {nested["field"]: nested["type"] for nested in field["fields"]}
        assert nested["warehouse_id"] == "int64"
        assert "warehouse_city" not in nested
        assert "warehouse_country" not in nested


def test_normalize_warehouse_returns_false_for_unknown_city():
    # Unknown warehouse cities are skipped instead of producing bad IDs.
    event = order_event("Unknown")
    original_payload = deepcopy(event.payload)
    original_schema = deepcopy(event.schema)

    assert event.normalize_warehouse({"Berlin": 1}) is False
    assert event.payload == original_payload
    assert event.schema == original_schema
