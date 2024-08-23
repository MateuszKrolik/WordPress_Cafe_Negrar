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

4. Run docker init
   - 1. Choose the latest stable php-apache image from dockerhub
   - 2. Choose ./wordpress as project root
   
5. In Dockerfile uncomment the "gd" section and add "mysqli" to it at the end:

```yaml
RUN apt-get update && apt-get install -y \
libfreetype-dev \
libjpeg62-turbo-dev \
libpng-dev \
&& rm -rf /var/lib/apt/lists/* \
&& docker-php-ext-configure gd --with-freetype --with-jpeg \
&& docker-php-ext-install -j$(nproc) gd mysqli
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
    environment:
      WORDPRESS_DB_HOST: db:3306
      WORDPRESS_DB_USER: wordpress
      WORDPRESS_DB_PASSWORD: wordpress
      WORDPRESS_DB_NAME: wordpress
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

7. Script for building for production outside compose and local testing (the network network part is optional and for local testing only):

```sh
#! /bin/bash

docker build --platform=linux/amd64 -t your_name/your_project:latest .

docker run -d -p 9000:80 \
  --network your_project_wordpress-network \
  -e WORDPRESS_DB_HOST=your_host \
  -e WORDPRESS_DB_USER=your_user \
  -e WORDPRESS_DB_PASSWORD=your_password \
  -e WORDPRESS_DB_NAME=your_name \
  your_name/your_project:latest
```

8. Push image to dockerhub:

```sh
docker login

docker push your_name/your_project:latest
```
