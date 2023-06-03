init: docker-down docker-pull docker-build docker-up
up: docker-up
down: docker-down
restart: up down

docker-up:
	docker-compose up -d

docker-down:
	docker-compose down --remove-orphans

docker-pull:
	docker-compose pull

docker-build:
	docker-compose build --pull

docker-create-network:
	docker network create traefik-public \
    docker network create app-network

show-jenkins-password:
	docker-compose exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
