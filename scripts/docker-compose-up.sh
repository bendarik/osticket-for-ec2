#!/bin/bash

# Start Docker Compose PROXY
if sudo test -f ./certbot/conf/live/baobabka.com/fullchain.pem; then
    
    cp ./nginx/nginx-https.conf ./nginx/nginx.conf
    sudo docker compose -f ./docker-compose-proxy.yaml up -d

else

    echo "[*] Starting nginx in HTTP-only mode..."
    cp ./nginx/nginx-http.conf ./nginx/nginx.conf
    sudo docker compose -f ./docker-compose-proxy.yaml up -d

    echo "[*] Waiting for nginx to start..."
    sleep 5

    echo "[*] Replacing nginx config with HTTPS version..."
    cp ./nginx/nginx-https.conf ./nginx/nginx.conf

    echo "[*] Restarting nginx with HTTPS..."
    sudo docker compose -f ./docker-compose-proxy.yaml stop nginx
    sudo docker compose -f ./docker-compose-proxy.yaml start nginx

    echo "[✔] Setup complete."

fi
echo "Docker Compose PROXY started successfully."


# Start Docker Compose APP
sudo docker compose -f ./docker-compose-app.yaml up -d
if [ $? -ne 0 ]; then
    echo "Failed to start Docker Compose APP."
    exit 1
else
    echo "Docker Compose APP started successfully."
fi
