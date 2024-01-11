#!/bin/bash

# Run Postgresql database
sudo docker run -d -p 5433:5432 --name db -e POSTGRES_PASSWORD=trasauser -e POSTGRES_USER=trasauser -e POSTGRES_DB=trasadb postgres

# Run Redis
sudo docker run -d -p 6380:6379 --name redis redis

# Run Guacd Server
sudo docker run -d --rm --name guacd -p 127.0.0.1:4822:4822 -v /tmp/trasa/accessproxy/guac:/tmp/trasa/accessproxy/guac --user root seknox/guacd:v0.0.1

# Run TRASA server
sudo docker run -d \
  --link db:db \
  --link guacd:guacd \
  --link redis:redis \
  -p 8443:443 \
  -p 8080:80 \
  -p 8022:8022 \
  -e TRASA.LISTENADDR=0.0.0.0 \
  -e TRASA.AUTOCERT="false" \
  -v /tmp/trasa/accessproxy/guac:/tmp/trasa/accessproxy/guac \
  seknox/trasa:v1.1.4
