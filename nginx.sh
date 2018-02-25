#!/bin/bash

start() {
    CONTAINER_ID=$(docker ps -a -f NAME=lua-opencage-geocoder-test -q)

    if [ ! -z "$CONTAINER_ID" ]; then
        docker stop lua-opencage-geocoder-test >/dev/null
        docker rm lua-opencage-geocoder-test >/dev/null
    fi

    CONTAINER_ID=$(docker run --name lua-opencage-geocoder-test --expose 80 -p 80 -v `pwd`/nginx/nginx.conf:/etc/nginx/nginx.conf:ro -v `pwd`/nginx/html:/usr/share/nginx/html:ro -d nginx)
    DOCKER_PORT=$(docker port lua-opencage-geocoder-test 80 | cut -d':' -f2)

    try=0
    while [ $try -lt 10 ]
    do
        curl -s 127.0.0.1:$DOCKER_PORT >/dev/null 2>&1
        if [ $? -eq 0 ]; then
            break
        fi
        ((try++))
    done
}

stop() {
    docker stop lua-opencage-geocoder-test >/dev/null
    docker rm lua-opencage-geocoder-test >/dev/null
}

port() {
    echo $(docker port lua-opencage-geocoder-test 80 | cut -d':' -f2)
}

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  port)
    port
    ;;
  *)
    echo "Usage: $0 {start|stop|port}"
esac
