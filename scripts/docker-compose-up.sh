#!/bin/bash

# Start PROXY
sudo docker compose -f ../docker-compose-proxy.yaml up -d
if [ $? -ne 0 ]; then
    echo "Failed to start Docker Compose PROXY."
    exit 1
else
    echo "Docker Compose PROXY started successfully."
fi

# Start APP
sudo docker compose -f ../docker-compose-app.yaml up -d
if [ $? -ne 0 ]; then
    echo "Failed to start Docker Compose APP."
    exit 1
else
    echo "Docker Compose APP started successfully."
fi
