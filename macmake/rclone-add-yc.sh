#!/usr/bin/env bash

# check if rclone is installed
if ! command -v rclone &> /dev/null; then
	echo "rclone is not installed. Please install rclone first."
	exit 1
fi

# check if the rclone config file exists
if [ ! -f "$HOME/.config/rclone/rclone.conf" ]; then
	echo "rclone config file not found. Please run rclone config first."
	exit 1
fi

# ask for the rclone config name
read -erp "Enter the rclone config name: " config_name

# check if the config name is already in use
if grep -q "\[$config_name\]" "$HOME/.config/rclone/rclone.conf"; then
	echo "Config name $config_name is already in use."
	exit 1
fi

# ask for the access key
read -erp "Enter the access key: " access_key

# ask for the secret key
read -erp "Enter the secret key: " secret_key

# ask for bucket name
read -erp "Enter the bucket name: " bucket_name

# add the config to the rclone config file
echo "[$config_name]
type = s3
provider = Other
env_auth = false
access_key_id = $access_key
secret_access_key = $secret_key
region = ru-central1
endpoint = storage.yandexcloud.net
no_check_bucket = true
bucket = $bucket_name" >> "$HOME/.config/rclone/rclone.conf"

echo "Config [$config_name] added successfully to ~/.config/rclone/rclone.conf"
