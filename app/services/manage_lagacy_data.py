




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


def manage_legacy_data_main(data_batch: list[dict]):
    for event in data_batch:
        data = event.get("data")
        source = event.get("source")
        table = source.get("table")
        print("table:", table)
        print("data:", data)
