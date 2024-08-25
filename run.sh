#! /bin/bash

docker build --platform=linux/amd64 --no-cache -t mateuszkrolik/cafe-negrar:latest .

# docker run --platform=linux/amd64 -d -p 9000:80 \
#   --env-file .env \
#   -v ./app:/var/www/html \
#   mateuszkrolik/cafe-negrar:latest
