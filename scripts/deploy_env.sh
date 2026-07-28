#!/bin/bash
set -e

ENV_NAME=$1

if [ "$ENV_NAME" != "blue" ] && [ "$ENV_NAME" != "green" ]; then
    echo "Usage: $0 [blue|green]"
    exit 1
fi

echo "=========================================="
echo "Deploying to $ENV_NAME environment"
echo "=========================================="

# Set variables
CONTAINER_NAME="app_$ENV_NAME"
IMAGE_NAME="blue-green-app:$ENV_NAME"
PORT="3000"

# Build the new image
echo "Building Docker image $IMAGE_NAME..."
docker build -t $IMAGE_NAME .

# Stop and remove the old container if it exists
if docker ps -a --format '{{.Names}}' | grep -Eq "^${CONTAINER_NAME}\$"; then
    echo "Stopping existing container $CONTAINER_NAME..."
    docker stop $CONTAINER_NAME || true
    docker rm $CONTAINER_NAME || true
fi

# Run the new container
# In a real environment, we'd map to different host ports or use a Docker network.
# For Docker Compose, they will run on the same network.
echo "Starting new container $CONTAINER_NAME..."
docker run -d \
    --name $CONTAINER_NAME \
    --network netflix_default \
    -e APP_COLOR=$ENV_NAME \
    -e APP_VERSION=$(date +%s) \
    $IMAGE_NAME

echo "Container $CONTAINER_NAME is up and running!"
