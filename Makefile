LOGIN = jpflegha
DATA_PATH = $(HOME)/data
COMPOSE = docker compose -f src/docker-compose.yaml

all: setup
	#rc-service docker start
	$(COMPOSE) up -d --build

stop:
	$(COMPOSE) stop

start:
	$(COMPOSE) start

setup:
	mkdir -p $(DATA_PATH)/mariadb
	mkdir -p $(DATA_PATH)/wordpress

down:
	$(COMPOSE) down

clean: down
	$(COMPOSE) down -v --rmi all

fclean: down
	docker system prune -a --volumes -f
	docker volume rm $$(docker volume ls -q) 2>/dev/null || true
	docker network rm $$(docker network ls -q) 2>/dev/null || true
	sudo rm -rf $(DATA_PATH)

re: fclean all

ps:
	docker ps

logs:
	$(COMPOSE) logs -f
	
.PHONY: all setup down clean fclean re ps logs