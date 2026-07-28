#!/bin/bash
set -e

TARGET_ENV=$1

if [ "$TARGET_ENV" != "blue" ] && [ "$TARGET_ENV" != "green" ]; then
    echo "Usage: $0 [blue|green]"
    exit 1
fi

echo "=========================================="
echo "Switching traffic to $TARGET_ENV environment"
echo "=========================================="

# Copy the corresponding upstream config to active.conf
# We assume this script runs on the machine hosting the Nginx container volume,
# or we can execute a command inside the Nginx container.
# Here we just copy the file in the workspace, which is mounted into the Nginx container.

cp nginx/${TARGET_ENV}.conf nginx/active.conf

echo "Reloading Nginx configuration..."
# Assuming Nginx container is named "nginx_lb"
if docker ps --format '{{.Names}}' | grep -Eq "^nginx_lb\$"; then
    docker exec nginx_lb nginx -s reload
    echo "Traffic successfully switched to $TARGET_ENV!"
else
    echo "Warning: nginx_lb container not found. Did not reload Nginx."
    echo "However, the configuration file was updated."
fi
