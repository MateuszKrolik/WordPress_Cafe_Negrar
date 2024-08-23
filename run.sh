#! /bin/bash

docker build -t mateuszkrolik/cafe-negrar:latest .

docker run -d -p 9000:80 \
  --network cafe_negrar_app-network \
  -e WORDPRESS_DB_HOST=db:3306 \
  -e WORDPRESS_DB_USER=wordpress \
  -e WORDPRESS_DB_PASSWORD=wordpress \
  -e WORDPRESS_DB_NAME=wordpress \
  mateuszkrolik/cafe-negrar:latest