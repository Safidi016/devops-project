#!/bin/bash
IMAGE_NAME=$1
CONTAINER_NAME=staging-app

docker stop   $CONTAINER_NAME || true
docker rm     $CONTAINER_NAME || true
docker image prune -af
docker pull   $IMAGE_NAME
docker run -d --name $CONTAINER_NAME -p 3000:3000 $IMAGE_NAME