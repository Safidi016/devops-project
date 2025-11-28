#!/bin/bash
docker stop mon-app || true
docker rm mon-app || true
docker pull tonuser/mon-app:latest
docker run -d --name mon-app -p 3000:3000 tonuser/mon-app:latest