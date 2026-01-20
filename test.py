import json

dict = { "schema": { "type": "struct", "fields": [ { "type": "struct", "fields": [ { "type": "int64", "optional": False, "default": 0, "field": "id" }, { "type": "int64", "optional": False, "field": "customer_id" }, { "type": "string", "optional": False, "field": "warehouse_city" }, { "type": "string", "optional": False, "field": "warehouse_country" }, { "type": "int32", "optional": False, "field": "capacity" }, { "type": "int64", "optional": False, "name": "io.debezium.time.MicroTimestamp", "version": 1, "default": 0, "field": "created_at" } ], "optional": True, "name": "cdc.public.legacy_orders.Value", "field": "before" }, { "type": "struct", "fields": [ { "type": "int64", "optional": False, "default": 0, "field": "id" }, { "type": "int64", "optional": False, "field": "customer_id" }, { "type": "string", "optional": False, "field": "warehouse_city" }, { "type": "string", "optional": False, "field": "warehouse_country" }, { "type": "int32", "optional": False, "field": "capacity" }, { "type": "int64", "optional": False, "name": "io.debezium.time.MicroTimestamp", "version": 1, "default": 0, "field": "created_at" } ], "optional": True, "name": "cdc.public.legacy_orders.Value", "field": "after" }, { "type": "struct", "fields": [ { "type": "string", "optional": False, "field": "version" }, { "type": "string", "optional": False, "field": "connector" }, { "type": "string", "optional": False, "field": "name" }, { "type": "int64", "optional": False, "field": "ts_ms" }, { "type": "string", "optional": True, "name": "io.debezium.data.Enum", "version": 1, "parameters": { "allowed": "True,last,False,incremental" }, "default": "False", "field": "snapshot" }, { "type": "string", "optional": False, "field": "db" }, { "type": "string", "optional": True, "field": "sequence" }, { "type": "int64", "optional": True, "field": "ts_us" }, { "type": "int64", "optional": True, "field": "ts_ns" }, { "type": "string", "optional": False, "field": "schema" }, { "type": "string", "optional": False, "field": "table" }, { "type": "int64", "optional": True, "field": "txId" }, { "type": "int64", "optional": True, "field": "lsn" }, { "type": "int64", "optional": True, "field": "xmin" } ], "optional": False, "name": "io.debezium.connector.postgresql.Source", "field": "source" }, { "type": "struct", "fields": [ { "type": "string", "optional": False, "field": "id" }, { "type": "int64", "optional": False, "field": "total_order" }, { "type": "int64", "optional": False, "field": "data_collection_order" } ], "optional": True, "name": "event.block", "version": 1, "field": "transaction" }, { "type": "string", "optional": False, "field": "op" }, { "type": "int64", "optional": True, "field": "ts_ms" }, { "type": "int64", "optional": True, "field": "ts_us" }, { "type": "int64", "optional": True, "field": "ts_ns" } ], "optional": False, "name": "cdc.public.legacy_orders.Envelope", "version": 2 }, "payload": { "before": None, "after": { "id": 36214, "customer_id": 8923, "warehouse_city": "Stockholm", "warehouse_country": "Sweden", "capacity": 5, "created_at": 1768761382417773 }, "source": { "version": "2.7.3.Final", "connector": "postgresql", "name": "cdc", "ts_ms": 1768761382428, "snapshot": "False", "db": "legacy", "sequence": "[\"44074040\",\"44074040\"]", "ts_us": 1768761382428160, "ts_ns": 1.76876138242816e+18, "schema": "public", "table": "legacy_orders", "txId": 12856, "lsn": 44074040, "xmin": None }, "transaction": None, "op": "c", "ts_ms": 1768761382904, "ts_us": 1768761382904598, "ts_ns": 1.768761382904598e+18 }, "key": { "schema": { "type": "struct", "fields": [ { "type": "int64", "optional": False, "default": 0, "field": "id" } ], "optional": False, "name": "cdc.public.legacy_orders.Key" }, "payload": { "id": 36214 } } },


disp_tabel = {
  "Stockholm": 5,
  "Berlin": 3,
}


payloads = dict[0].get('payload').get('after')


def delete_field(payloads):
  payloads.pop('capacity')

def replace_warehouse_name_with_id(payloads):
  city = payloads.get('warehouse_city')
  if city is None:
    return

  wid = disp_tabel.get(city)
  if wid is None:
    return

  payloads['warehouse_city'] = wid


# payloads.pop('version', None)
# payloads.pop('db', None)


# payloads['new_field'] = f"{payloads.get('ts_us', None)} {payloads.get('ts_ns', None)}"
#
# payloads.pop('ts_us', None)
# payloads.pop('ts_ns', None)
#
# if "version" in payloads:
#     payloads["version"] = disp_tabel.get("2.7.3.Final", None)

delete_field(payloads)
replace_warehouse_name_with_id(payloads)


payloads_schema_list = dict[0].get('schema').get('fields')

payloads_schema = []
for schema in payloads_schema_list:
    fields = schema.get("fields")
    if not fields:
        continue

    for field in fields:
        if field.get("field") == "warehouse_country":
            continue

        if field.get("field") == "warehouse_city":
            field["field"] = "city_id"
            field["type"] = "int64"

        print(json.dumps(field, indent=2, ensure_ascii=False))