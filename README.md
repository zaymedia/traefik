### Предварительные настройки
1. Обновить список пакетов и установить утилиту make:
```
sudo apt update
sudo apt install make
```

2. Обновить docker compose до v2 для всех пользователей:
```
mkdir -p /usr/local/lib/docker/cli-plugins
curl -SL https://github.com/docker/compose/releases/download/v2.18.1/docker-compose-linux-x86_64 -o /usr/local/lib/docker/cli-plugins/docker-compose
sudo chmod +x /usr/local/lib/docker/cli-plugins/docker-compose
```
Официальная инструкция:
```
https://docs.docker.com/compose/install/linux/#install-the-plugin-manually
```

---

### Инструкция по запуску
1. Скопировать все файлы на сервер в директорию ../home/traefik
2. Заменить zay.media на свой домен в файле docker-compose.yml
3. Создать A-записи в DNS для поддоменов: jenkins, realtime, dockerhub
4. Настроить конфигурацию для centrifugo в файле: docker/centrifugo/config.json
5. Перейти в директорию ../home/traefik
6. Сгенерировать файл с авторизацией для dockerhub командой (указав свой логин и пароль вместо YOUR_LOGIN и YOUR_PASSWORD):
```
docker run registry:2.6 htpasswd -Bbn YOUR_LOGIN YOUR_PASSWORD > htpasswd
```
7. Создать сеть:
```
docker network create traefik-public
docker network create app-network
```
8. Запустить контейнеры в режиме демона:
```
make init
```
9. Узнать ключ для настройки jenkins с помощью команды:
```
make show-jenkins-password
```
10. Добавить плагин SSH Agent в Jenkins для возможности деплоя через ssh

---

### Создание пользователя для деплоя

1. Создать пользователя "deploy" (без пароля, вход только по публичному ключу):
```
sudo useradd -m -G sudo,docker deploy
```

2. Выдать пользователю "deploy" права на запись в директорию "/home":
```
sudo chown deploy:deploy /home
sudo chmod 700 /home
```

3. Переключиться на пользователя "deploy":
```
sudo su deploy
```

4. Создать папку ".ssh" и файл "authorized_keys" для пользователя "deploy":
```
mkdir ~/.ssh
touch ~/.ssh/authorized_keys
```

5. Скопировать свой публичный RSA ключ в файл "authorized_keys". Это можно сделать с помощью команды:
```
nano ~/.ssh/authorized_keys
```
Откроется текстовый редактор, в котором нужно вставить свой публичный ключ и сохранить изменения.<br>
Локально публичный ключ находится в папке: ~/.ssh (файл id_rsa.pub)

6. Установить права доступа к папке ".ssh" и файлу "authorized_keys":
```
chmod 700 ~/.ssh && chmod 600 ~/.ssh/authorized_keys
```

7. В Jenkins для деплоя через RSA ключ необходимо указывать приватный ключ (файл id_rsa)
---

### Полезные команды
Перезапустить контейнеры:
```
make restart
```

Перезапустить контейнеры с обновлением:
```
make init
```

Просмотр логов:
```
docker compose logs -f -t
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
docker compose exec docker docker system prune -af --filter until=240h
```
Очистить неиспользуемые образа через сборщик мусора:
```
docker compose exec dockerhub bin/registry garbage-collect /dockerhub/garbage.yml [--delete-untagged]
```

Если команды выше не помогают, можно удалить директорию:
```
rm -rf /var/lib/docker/volumes/traefik_dockerhub/_data/docker/registry/v2
```
