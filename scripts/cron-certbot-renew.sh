#!/bin/bash

# Backup the current crontab
crontab -l > mycron 2>/dev/null

# Add a new job (example: run /path/to/script.sh every day at midnight)
echo "0 5 1 */2 * sudo /usr/bin/docker compose -f /home/ubuntu/osticket-for-ec2/docker-compose-proxy.yaml up certbot -d" >> mycron

# Install the new crontab
crontab mycron
rm mycron