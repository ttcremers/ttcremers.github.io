.DEFAULT_GOAL := help

.PHONY: help up down logs build status

help:
	@echo Available targets:
	@echo   make up      Start the local Hugo server
	@echo   make down    Stop the local Hugo server
	@echo   make logs    Show local Hugo server logs
	@echo   make build   Run a production Hugo build in Docker
	@echo   make status  Show Docker Compose service status

up:
	docker --config .docker compose up -d

down:
	docker --config .docker compose down

logs:
	docker --config .docker compose logs --no-color --tail 100

build:
	docker --config .docker compose run --rm -e HUGO_ENVIRONMENT=production -e HUGO_ENV=production server --minify --baseURL https://zone.photos/

status:
	docker --config .docker compose ps
