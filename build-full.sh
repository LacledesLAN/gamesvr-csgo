#!/bin/bash
set -e

##
## This script will do a full update to gamesvr-csgo, so it can then be pushed to
## DockerHUB
##

echo -e '\n\033[1m[Preflight Checks]\033[0m'
echo -e "Docker client version: '$(docker version --format '{{.Client.Version}}')'"
echo -e "Docker server version: '$(docker version --format '{{.Server.Version}}')'"

echo -e '\n\033[1m[Grabbing]\033[0m'
docker pull lacledeslan/steamcmd:latest


echo -e '\n\033[1m[Build Image]\033[0m'
docker build . -f linux.Dockerfile --rm -t lacledeslan/gamesvr-csgo:latest --no-cache --pull --build-arg BUILDNODE=$env:computername;
docker run -it --rm lltest/gamesvr-csgo:latest ./ll-tests/gamesvr-csgo.sh;

echo -e '\n\033[1m[Results]\033[0m'
echo -e 'Image created, to push to Docker HUB run command:\n'
echo -e '\t\tdocker push lacledeslan/gamesvr-csgo:base && docker push lacledeslan/gamesvr-csgo:latest\n'
