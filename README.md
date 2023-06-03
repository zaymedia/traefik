### Инструкция по запуску
1. Скопировать все файлы на сервер в директорию ../home/traefik
2. Заменить zay.media на свой домен в файле docker-compose.yml
3. Создать A-записи в DNS для поддоменов: jenkins, realtime, dockerhub
4. Настроить конфигурацию для centrifugo в файле: docker/centrifugo/config.json
5. Перейти в директорию ../home/traefik
6. Сгенерировать файл с авторизацией для dockerhub командой (указав свой логин и пароль):
```
docker run registry:2.6 htpasswd -Bbn YOUR_login YOUR_password > htpasswd
```
7. Создать сеть:
```
make docker-create-network
```
8. Запустить контейнеры в режиме демона:
```
make init
```
9. Узнать ключ для настройки jenkins с помощью команды:
```
make show-jenkins-password
```

---

### Полезные команды

Просмотр логов:
```
docker-compose logs -f -t
```
Список всех контейнеров:
```
docker ps -la
```

---

### Освобождение дискового пространства

Очистить неиспользуемые образа:
```
docker system prune --all
```
Очистить неиспользуемые образа в docker для jenkins:
```
docker-compose exec docker docker system prune -af --filter until=240h
```
Очистить неиспользуемые образа через сборщик мусора:
```
docker-compose exec dockerhub bin/registry garbage-collect /dockerhub/garbage.yml [--delete-untagged]
```

Если команды выше не помогают, можно удалить директорию:
```
rm -rf /var/lib/docker/volumes/traefik_dockerhub/_data/docker/registry/v2
```

---

### Деплой сервисов

Создание пользователя для деплоя:
```
useradd deploy
passwd deploy
usermod -aG sudo deploy
usermod -aG docker deploy
mkdir /home/deploy
mkdir /home/deploy/.ssh
chmod 700 /home/deploy/.ssh
usermod -s /bin/bash deploy
```

Добавления ssh ключа на сервер:
```
ssh-copy-id -i ~/.ssh/id_rsa.pub deploy@host
```
