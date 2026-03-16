all: build up

build:
	docker compose -f srcs/docker-compose.yml build

up:
	docker compose -f srcs/docker-compose.yml up -d

down:
	docker compose -f srcs/docker-compose.yml down

clean: down
	docker compose -f srcs/docker-compose.yml down -v --rmi local

re: down all

logs:
	docker compose -f srcs/docker-compose.yml logs -f

ps:
	docker compose -f srcs/docker-compose.yml ps

.PHONY: all build up down clean re