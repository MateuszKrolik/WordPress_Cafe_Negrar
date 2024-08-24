#! /bin/bash

docker build --no-cache -t mateuszkrolik/cafe-negrar:latest .

docker run -d -p 9000:80 \
  --network cafe_negrar_app-network \
  --env-file .env \
  mateuszkrolik/cafe-negrar:latest
