COMPOSE = docker compose \
	-f docker-compose.infra.yml \
	-f docker-compose.fastapi.yml \
	-f docker-compose.monitoring.yml

.PHONY: up down test ps logs

up:
	$(COMPOSE) up -d --build

down:
	$(COMPOSE) down

test:
	docker compose -p cdc_tests -f docker-compose.tests.yml up --build --exit-code-from api_tests

ps:
	$(COMPOSE) ps

logs:
	docker logs -f faker_app
