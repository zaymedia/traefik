### Создание пользователя для деплоя
- ```useradd deploy```
- ```passwd deploy```
- ```usermod -aG sudo deploy```
- ```usermod -aG docker deploy```
- ```mkdir /home/deploy```
- ```mkdir /home/deploy/.ssh```
- ```chmod 700 /home/deploy/.ssh```
- ```usermod -s /bin/bash deploy```

### Добавления ssh ключа на сервер
```ssh-copy-id -i ~/.ssh/id_rsa.pub deploy@host```

### Генерация логин/пароль для закрытия репозитория (registry - логин, password - пароль)
docker run registry:2.6 htpasswd -Bbn registry password > htpasswd

### Перезапуск контейнеров (только docker-compose)
```docker-compose down --remove-orphans && docker-compose up -d```

### Просмотр логов
- ```docker-compose logs -f -t```
- ```docker ps -la```
- ```docker logs```

### Если нет сети, то создать её командой
```docker network create traefik-public```
```docker network create app-network```

### Перезапуск всех контейнеров (весь docker)
```docker restart $(docker ps -q)```

### Освобождение дискового пространства
```rm -rf /var/lib/docker/volumes/traefik_dockerhub/_data/docker/registry/v2```

### Очистить неиспользуемые образа
```docker system prune --all```
```docker-compose exec docker docker system prune -af --filter until=240h```
```docker-compose exec dockerhub bin/registry garbage-collect /dockerhub/garbage.yml [--delete-untagged]```
