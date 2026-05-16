# CDC Zero-Downtime Migration Pipeline

This project is a local CDC pipeline for moving data from a legacy PostgreSQL database into a cleaner target database without changing the source application.

The source database is treated as a system that already exists in production. Debezium reads changes from PostgreSQL WAL, Kafka keeps the raw CDC stream durable, a FastAPI worker transforms events into a cleaner model, and Kafka Connect writes the transformed records into the target database.

The project is built to demonstrate the parts of a backend/data migration system that are easy to miss in small portfolio projects: CDC setup, offset handling, transformation boundaries, connector configuration, health checks, tests, and observability.

![Architecture diagram](readme_assets/arch_diagram_cdc.png)

## Stack

- PostgreSQL for the legacy and clean databases
- Debezium for CDC from PostgreSQL logical replication
- Kafka for buffering raw and transformed events
- Kafka Connect JDBC Sink for writing transformed topics to the clean database
- FastAPI background worker for event transformation
- Grafana, Prometheus, Loki, and Promtail for monitoring and logs
- Docker Compose for local infrastructure

## Data Flow

1. The generator inserts synthetic customers and orders into the legacy database.
2. Debezium streams inserts and updates from `legacy_customers` and `legacy_orders` into Kafka topics.
3. The FastAPI worker consumes the raw CDC topics, transforms the payloads, and publishes cleaned events.
4. Kafka Connect JDBC Sink writes cleaned customer and order events into the target database.
5. Health checks, metrics, and structured logs are available through the monitoring stack.

Raw Debezium topics are kept separate from transformed topics:

```text
cdc.public.legacy_customers  ->  cleared_customers  ->  clean.customers
cdc.public.legacy_orders     ->  cleared_orders     ->  clean.orders
```

## Local Setup

Create a local environment file:

```bash
cp .env.example .env
```

Start the full stack:

```bash
make up
```

Check running services:

```bash
make ps
```

Run tests:

```bash
make test
```

Follow the application logs:

```bash
make logs
```

Stop the stack:

```bash
make down
```

The same stack can also be started directly with Docker Compose:

```bash
docker compose \
  -f docker-compose.infra.yml \
  -f docker-compose.fastapi.yml \
  -f docker-compose.monitoring.yml \
  up -d --build
```

## Services

| Service | URL / port | Notes |
| --- | --- | --- |
| FastAPI | `http://localhost:8000` | Runs the generator and CDC consumer worker |
| Health check | `http://localhost:8000/health` | Checks Kafka, databases, and Kafka Connect connectors |
| Kafka Connect | `http://localhost:8083` | Debezium source and JDBC sink connectors |
| Kafdrop | `http://localhost:9000` | Kafka topic browser |
| Grafana | `http://localhost:3000` | Dashboards and logs |
| Prometheus | `http://localhost:9090` | Metrics |
| pgAdmin | `http://localhost:8889` | Optional database UI |

Default local Grafana credentials are `admin / admin`, unless an existing Grafana volume already contains another password.

## Transformation Worker

The FastAPI service starts two background tasks on startup:

- an auto-generator that continuously writes sample customers and orders to the legacy database;
- a Kafka consumer that reads CDC events from the raw Debezium topics.

The consumer uses manual offset commits:

- `enable.auto.commit` is disabled;
- CDC messages are processed in batches;
- offsets are committed only after the transformation pipeline completes successfully;
- if processing or Kafka production fails, offsets are not committed and the batch can be retried.

This gives the pipeline at-least-once processing semantics. Transformations should therefore stay idempotent, because the same event may be processed again after a failure.

Examples of transformations:

- split legacy customer names into cleaner fields;
- map source values into target-friendly structures;
- route transformed records into `cleared_customers` and `cleared_orders`.

## Kafka Connect

Connector definitions are stored as templates in `connector/*.json.template`.

At startup, init containers render those templates from environment variables and register the connectors through the Kafka Connect REST API. This keeps local credentials out of tracked connector JSON files while still making the setup reproducible.

The source connector reads from the legacy PostgreSQL database with Debezium. The sink connector writes transformed Kafka topics into the clean PostgreSQL database.

## Observability

Grafana includes a CDC overview dashboard with:

- service health status;
- generated customer and order activity;
- recent pipeline events;
- structured logs grouped by pipeline stage;
- Kafka consumer logs showing successful offset commits after processing.

![Monitoring dashboard](readme_assets/monitoring_cdc.png)

Logs are written as structured application logs and collected by Promtail into Loki. Prometheus is used for metrics and service health visibility.

## Tests

The test suite focuses on the behavior that matters most for the pipeline:

- CDC event transformation;
- health-check behavior;
- Kafka consumer parsing;
- offset commit behavior;
- producer failure handling.

Run tests with:

```bash
make test
```

## Project Layout

```text
app/
  kafka_consumer.py          # manual Kafka consumer and offset handling
  main.py                    # FastAPI app and background workers
  services/
    manage_lagacy_data.py    # CDC transformation pipeline
    health_check.py          # service health checks
    fake_data_generator.py   # synthetic legacy data generator

connector/
  *.json.template            # Kafka Connect source and sink templates

grafana/
  dashboards/                # provisioned dashboard JSON
  provisioning/              # Grafana datasources and dashboard config

prometheus/
  prometheus.yml             # Prometheus config
  promtail-config.yml        # Promtail config

tests/
  test_*.py                  # focused pipeline and consumer tests
```

## Notes

This is a local demonstration project, not a production deployment. It intentionally keeps the infrastructure compact so the whole pipeline can run through Docker Compose.

The important design choices are still production-oriented:

- source and target databases are separated;
- raw CDC events are not mutated;
- Kafka offsets are committed after successful processing;
- connector config is template-based;
- logs and health checks expose the state of the pipeline;
- tests cover failure paths around offset commits and producer errors.

Possible next improvements:

- add consumer lag metrics;
- add dead-letter handling for invalid events;
- add schema migration tooling for the clean database;
- add dashboard panels for error rate and processing throughput.
