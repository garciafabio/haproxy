#!/bin/bash

docker run --name lb -d \
    -e CERTS=my.domain,my.other.domain \
    -e EMAIL=my.email@my.domain \
    -e STAGING=true \
    -v './data/folder:/etc/letsencrypt' \
    -v './data/haproxycfg/haproxy.cfg:/etc/haproxy/haproxy.cfg' \
    --network alyantNet \
    -p 80:80 -p 443:443 \
    docker-haproxy-certbot:latest
