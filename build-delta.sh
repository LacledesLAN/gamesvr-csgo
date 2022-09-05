#!/bin/bash
set -e

##
## This script will do a quick update to gamesvr-csgo, creating a "delta" layer, that can then be pushed to
## DockerHUB. Image is not as clean as building from scratch - but this process is significantly faster and
## good for tight deadlines.
##

echo -e '\n\033[1m[Preflight Checks]\033[0m'
echo -e "Docker client version: '$(docker version --format '{{.Client.Version}}')'"
echo -e "Docker server version: '$(docker version --format '{{.Server.Version}}')'"


echo -e '\n\033[1m[Grabbing and Extracting SteamCMD]\033[0m'
# to bad `--volumes-from` doesn't support path aliasing ヽ(ಠ_ಠ)ノ
docker pull lacledeslan/steamcmd:latest
docker container rm LLSteamCMD-Extractor &>/dev/null || true
docker create --name LLSteamCMD-Extractor lacledeslan/steamcmd:latest
docker cp LLSteamCMD-Extractor:/app "$(pwd)/.steamcmd/linux"
docker container rm LLSteamCMD-Extractor


echo -e '\n\033[1m[Building Delta Container]\033[0m'
docker pull lacledeslan/gamesvr-csgo:base
docker container rm LL-CSGO-DELTA-CAPTURE &>/dev/null || true
docker run -it --name LL-CSGO-DELTA-CAPTURE \
    --mount type=bind,source="$(pwd)"/.steamcmd/linux/app/,target=/steamcmd/ \
    lacledeslan/gamesvr-csgo \
    /steamcmd/steamcmd.sh +login anonymous +force_install_dir /app +app_update 740 +quit


echo -e '\n\033[1m[Commiting Delta Container to Image]\033[0m'
docker commit --change='CMD ["/bin/bash"]' --message="Content delta update $(date '+%d/%m/%Y %H:%M:%S')" "$(docker ps -aqf "name=LL-CSGO-DELTA-CAPTURE")" lacledeslan/gamesvr-csgo:latest
docker container rm LL-CSGO-DELTA-CAPTURE

echo -e '\n\033[1m[Running Image Self-Checks]\033[0m'
docker run -it --rm lacledeslan/gamesvr-csgo:latest ./ll-tests/gamesvr-csgo.sh


echo -e '\n\033[1m[Pushing to Docker Hub]\033[0m'
docker push lacledeslan/gamesvr-csgo:latest
