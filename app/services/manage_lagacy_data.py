




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
    before = {
        "table": None,
        "data": []
    }

    after = {
        "table": None,
        "data": []
    }

    for event in data_batch:
        source = event.get("source", {})
        table = source.get("table")

        if table:
            # table одна и та же для всего батча
            before["table"] = before["table"] or table
            after["table"] = after["table"] or table

        if event.get("before"):
            before["data"].append(event["before"])

        if event.get("after"):
            after["data"].append(event["after"])

    if before["data"]:
        before_data(before)

    if after["data"]:
        after_data(after)
