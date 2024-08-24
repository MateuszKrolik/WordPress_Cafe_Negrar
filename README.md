# Cafe Negrar

## WP SetUp

1. Download latest wordpress source-code

```sh
curl -O https://wordpress.org/latest.tar.gz
```

2. Extract it

```sh
tar -xzf latest.tar.gz
```

3. Remove leftovers:

```sh
rm latest.tar.gz
```

4. Run

```sh
  docker init
```

- 1.  Choose the latest stable php-apache image from dockerhub
- 2.  Choose ./wordpress as project root

5. In Dockerfile uncomment the "gd" section and add "mysqli" to it at the end:

```yaml
RUN apt-get update && apt-get install -y \
libfreetype-dev \
libjpeg62-turbo-dev \
libpng-dev \
&& rm -rf /var/lib/apt/lists/* \
&& docker-php-ext-configure gd --with-freetype --with-jpeg \
&& docker-php-ext-install -j$(nproc) gd mysqli # add "mysqli" here
```

6. Edit the Compose file and add a shared network, so the db can be accessed w/o compose later for testing purposes before deployment and add volumes for persistance:

```yaml
services:
  server:
    build:
      context: .
    ports:
      - '9000:80'
    depends_on:
      - db
    env_file:
      - .env
    volumes:
      - ./wordpress:/var/www/html
    networks:
      - wordpress-network

  db:
    image: mysql:latest
    environment:
      MYSQL_ROOT_PASSWORD: password
      MYSQL_DATABASE: wordpress
      MYSQL_USER: wordpress
      MYSQL_PASSWORD: wordpress
    volumes:
      - db_data:/var/lib/mysql
    networks:
      - wordpress-network

  phpmyadmin:
    image: phpmyadmin/phpmyadmin
    ports:
      - '8080:80'
    environment:
      PMA_HOST: db
      MYSQL_ROOT_PASSWORD: password
    platform: linux/amd64
    networks:
      - wordpress-network

volumes:
  db_data:

networks:
  wordpress-network:
```

7. Script to build for production outside compose (the "docker run" part is optional and for local testing before deployment only):

```sh
#! /bin/bash

docker build --platform=linux/amd64 --no-cache -t your_name/your_project:latest .

docker run -d -p 9000:80 \
  --network your_project_wordpress-network \
  --env-file .env \
  your_name/your_project:latest
```

8. Push image to DockerHub Registry and host it somewhere (remember to provide the "WORDPRESS_DB..." EnvVars in the Cloud Environment):

```sh
docker login

docker push your_name/your_project:latest
```
