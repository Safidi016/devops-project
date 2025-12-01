#!/bin/bash
IMAGE_NAME=$1          # premier argument passé par Jenkins
CONTAINER_NAME=staging-app

sudo docker stop $CONTAINER_NAME || true
sudo docker rm $CONTAINER_NAME   || true
sudo docker image prune -f
sudo docker pull $IMAGE_NAME
sudo docker run -d --name $CONTAINER_NAME -p 3000:3000 $IMAGE_NAME