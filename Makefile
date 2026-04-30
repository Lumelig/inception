LOGIN = jpflegha
DATA_PATH = /home/jpflegha/data
COMPOSE = docker compose -f src/docker-compose.yaml

all: $(DATA_PATH)
	rc-service docker start
	$(COMPOSE) up -d --build

$(DATA_PATH):
	mkdir -p $(DATA_PATH)/mariadb
	mkdir -p $(DATA_PATH)/wordpress

down:
	$(COMPOSE) down

clean: down
	$(COMPOSE) down -v --rmi all

fclean: down
	docker system prune -a --volumes -f
	sudo rm -rf $(DATA_PATH)/mariadb
	sudo rm -rf $(DATA_PATH)/wordpress

re: clean all

ps:
	docker ps

logs:
	$(COMPOSE) logs -f

.PHONY: all down clean re ps logs