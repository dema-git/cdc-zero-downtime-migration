from app.models import CDCEvent

def before_data(data: dict):
    table = data.get("table")
    for item in data.get("data", []):
        print("item:", item)
        print("table:", table)


def after_data(data: dict):
    table = data.get("table")
    for item in data.get("data", []):
        print("item:", item)
        print("table:", table)


def manage_legacy_data_main(data_batch: list[CDCEvent]):
    for event in data_batch:
        if event.table_name == 'legacy_customers':
            data_to_send = event.with_split_name()

