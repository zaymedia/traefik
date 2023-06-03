init: docker-down docker-pull docker-build docker-up
up: docker-up
down: docker-down

docker-up:
	docker-compose up -d

docker-down:
	docker-compose down --remove-orphans

docker-pull:
	docker-compose pull

docker-build:
	docker-compose build --pull

show-jenkins-password:
	docker-compose exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
