#!/bin/bash

user="$1"
ssh_key="$2"

exit_code=0

if [ -z "$user" ]; then
    echo "No username provided."
    exit_code=1
else
    # Check if the user already exists
    existing_user=$(id -u "$user" 2>/dev/null)
    if [ -n "$existing_user" ]; then
        echo "User '$user' already exists."
        exit_code=1
    fi
fi

if [ -z "$ssh_key" ]; then
    echo "No SSH key provided."
    exit_code=1
fi

if [ $exit_code -eq 1 ]; then
    exit 1
fi

# Create a new user with sudo privileges
sudo adduser --disabled-password --gecos "" --quiet "$user"
sudo usermod -aG sudo "$user"

echo "User '$user' is created with sudo privileges."

# Create .ssh directory and authorized_keys file for the new user
sudo mkdir -p /home/"$user"/.ssh
echo "$ssh_key" | sudo tee /home/"$user"/.ssh/authorized_keys > /dev/null

# Set the correct permissions for the .ssh directory and authorized_keys file
sudo chown -R "$user":"$user" /home/"$user"/.ssh
sudo chmod 700 /home/"$user"/.ssh
sudo chmod 600 /home/"$user"/.ssh/authorized_keys

echo "SSH key is added. User '$user' can now log in using SSH."