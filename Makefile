LOGIN = jpflegha
DATA_PATH = /home/$(LOGIN)/inception
COMPOSE = docker compose -f src/docker-compose.yaml

all: $(DATA_PATH)
	sudo service docker start
	$(COMPOSE) up -d --build

$(DATA_PATH):
	mkdir -p $(DATA_PATH)/mariadb
	mkdir -p $(DATA_PATH)/wordpress

down:
	$(COMPOSE) down

clean: down
	$(COMPOSE) down -v --rmi all
	sudo rm -fr $(DATA_PATH)

re: clean all

ps:
	$(COMPOSE) ps

logs:
	$(COMPOSE) logs -f

.PHONY: all down clean re ps logs