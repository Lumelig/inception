LOGIN = jpflegha
DATA_PATH = /home/jpflegha/data
COMPOSE = docker compose -f src/docker-compose.yaml

all: setup
	rc-service docker start
	$(COMPOSE) up -d --build

setup:
	mkdir -p $(DATA_PATH)/mariadb
	mkdir -p $(DATA_PATH)/wordpress

down:
	$(COMPOSE) down

clean: down
	$(COMPOSE) down -v --rmi all

fclean: down
	docker system prune -a --volumes -f
	rm -rf $(DATA_PATH)/mariadb
	rm -rf $(DATA_PATH)/wordpress

re: fclean all

ps:
	docker ps

logs:
	$(COMPOSE) logs -f
	
.PHONY: all setup down clean fclean re ps logs