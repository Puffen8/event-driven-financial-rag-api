# Load environment variables from the root .env
include .env
export

# Configuration variables
COMPOSE_CMD := docker compose --env-file .env -f infrastructure/docker-compose.yml
INFRA_P     := --profile infra

.PHONY: help infra-up infra-down infra-logs infra-clean

help: ## Show this help message
	@grep -Eh '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-15s\033[0m %s\n", $$1, $$2}'

infra-up: ## Start the core infrastructure (Postgres, Kafka, Flink)
	$(COMPOSE_CMD) $(INFRA_P) up -d

infra-down: ## Stop the infrastructure containers
	$(COMPOSE_CMD) $(INFRA_P) down

infra-logs: ## Follow logs for all infrastructure services
	$(COMPOSE_CMD) $(INFRA_P) logs -f

infra-clean: ## Stop and remove volumes (WARNING: Deletes all DB/Kafka data)
	$(COMPOSE_CMD) $(INFRA_P) down -v