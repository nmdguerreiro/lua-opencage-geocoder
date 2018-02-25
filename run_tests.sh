#!/bin/bash

./nginx.sh start

PORT=$(./nginx.sh port)

echo "PORT=$PORT" > "./spec/helper.lua"
busted

./nginx.sh stop
