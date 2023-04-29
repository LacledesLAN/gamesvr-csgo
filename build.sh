#!/bin/bash
set -e;
set -u;


####################################################################################################
## Options
####################################################################################################

# Default options
option_delta_updates=false;	# Only build delta layer at the base image level?

# Parse command line options
while [ "$#" -gt 0 ]
do
	case "$1" in
		# options
		-d|--delta)
			option_delta_updates=true;
			;;
		# unknown
		*)
			echo "Error: unknown option '${1}'. Exiting." >&2;
			exit 12;
			;;
	esac
	shift
done;


####################################################################################################
## Helper Functions
####################################################################################################

# Custom sigterm handler, so that interupt signals terminate the script, not just a single command.
sigterm_handler() {
	echo -e "\n";
	exit 1;
}

trap 'trap " " SIGINT SIGTERM SIGHUP; kill 0; wait; sigterm_handler' SIGINT SIGTERM SIGHUP;


####################################################################################################
## Build
####################################################################################################

if [ "$option_delta_updates" != 'true' ]; then
    #
    # Full Update
    #

    echo -e '\n\033[1m[Build Full Image]\033[0m';
    docker build . -f linux.Dockerfile --rm -t lacledeslan/gamesvr-csgo:latest --no-cache --pull --build-arg BUILDNODE="$(cat /proc/sys/kernel/hostname)";
else
    #
    # Delta Update
    #

    echo -e '\n\033[1m[Grabbing and Extracting SteamCMD]\033[0m';
    # to bad `--volumes-from` doesn't support path aliasing ヽ(ಠ_ಠ)ノ
    docker container rm LLSteamCMD-Extractor &>/dev/null || true
    docker create --name LLSteamCMD-Extractor lacledeslan/steamcmd:latest;
    docker cp LLSteamCMD-Extractor:/app "$(pwd)/.steamcmd/linux";
    docker container rm LLSteamCMD-Extractor;


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
fi;


echo -e '\n\033[1m[Running Image Self-Checks]\033[0m';
docker run -it --rm lacledeslan/gamesvr-csgo:latest ./ll-tests/gamesvr-csgo.sh;


echo -e '\n\033[1m[Pushing to Docker Hub]\033[0m';

if [ "$option_delta_updates" != 'true' ]; then
    #
    # Full Update
    #

    docker tag lacledeslan/gamesvr-csgo:latest lacledeslan/gamesvr-csgo:base
    echo "> push lacledeslan/gamesvr-csgo:base"
    docker push lacledeslan/gamesvr-csgo:base
    echo "> push lacledeslan/gamesvr-csgo:latest"
    docker push lacledeslan/gamesvr-csgo:latest
else
    #
    # Delta Update
    #

    echo "> push lacledeslan/gamesvr-csgo:latest"
    docker push lacledeslan/gamesvr-csgo:latest
fi;
