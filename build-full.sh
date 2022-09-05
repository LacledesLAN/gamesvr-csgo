#!/bin/bash
set -e

##
## This script will do a full update to gamesvr-csgo, so it can then be pushed to
## DockerHUB
##

echo -e '\n\033[1m[Preflight Checks]\033[0m'
echo -e "Docker client version: '$(docker version --format '{{.Client.Version}}')'"
echo -e "Docker server version: '$(docker version --format '{{.Server.Version}}')'"


echo -e '\n\033[1m[Build Image]\033[0m'
docker build . -f linux.Dockerfile --rm -t lacledeslan/gamesvr-csgo:latest --no-cache --pull --build-arg BUILDNODE=$(cat /proc/sys/kernel/hostname);


echo -e '\n\033[1m[Running Self-Checks]\033[0m'
docker run -it --rm lacledeslan/gamesvr-csgo:latest ./ll-tests/gamesvr-csgo.sh


echo -e '\n\033[1m[Pushing to Docker Hub]\033[0m'
docker tag lacledeslan/gamesvr-csgo:latest lacledeslan/gamesvr-csgo:base
echo "> push lacledeslan/gamesvr-csgo:base"
docker push lacledeslan/gamesvr-csgo:base
echo "> push lacledeslan/gamesvr-csgo:latest"
docker push lacledeslan/gamesvr-csgo:latest
