# see howto.prepare_for_deploy.txt

SSH_KEY="~/.ssh/cicd-dc-oraclus-demo"

.PHONY: all pull push

all: ps logs up stop down pull

ps:
	docker-compose ps

logs:
	docker-compose logs

up:
	docker-compose up -d

stop:
	docker-compose stop

down:
	docker-compose down

pull:
	git pull
