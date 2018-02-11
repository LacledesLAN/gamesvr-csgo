# escape=`
FROM lacledeslan/steamcmd:linux as csgo-builder

RUN echo "Downloading content from LL public ftp server" &&`
        mkdir --parents /tmp/maps/ /output &&`
        cd /tmp/maps/ &&`
        wget -m `
            ftp://llgameserverbot:6gDyfNJhm4UsraE5@raw.content.lacledeslan.net/csgo/maps/ `
            -nH --no-verbose --cut-dirs 4 &&`
        rm -f .listing &&`
    echo "Decompressing files" &&`
        bzip2 --decompress /tmp/maps/*.*.bz2 &&`
        rm -f /tmp/maps/*.bz2 &&`
    echo "Moving uncompressed files to destination" &&`
        mkdir --parents /output/csgo/maps/ &&`
        mv /tmp/maps/*.bsp /output/csgo/maps/ &&`
        mv /tmp/maps/*.nav /output/csgo/maps/ &&`
    echo "Performing Cleanup" &&`
        rm -rf /tmp/*/*;

#=======================================================================
FROM debian:stable-slim

ARG BUILDNODE=unspecified
ARG SOURCE_COMMIT=unspecified

HEALTHCHECK NONE

RUN dpkg --add-architecture i386 &&`
    apt-get update && apt-get install -y `
        ca-certificates lib32gcc1 lib32tinfo5 libcurl4-gnutls-dev:i386 libstdc++6 libstdc++6:i386 libtcmalloc-minimal4:i386 locales locales-all procps screen tmux &&`
    apt-get clean &&`
    rm -rf /tmp/* /var/lib/apt/lists/* /var/tmp/*;

ENV LANG=en_US.UTF-8 LANGUAGE=en_US.UTF-8 LC_ALL=en_US.UTF-8 

LABEL maintainer="Laclede's LAN <contact @lacledeslan.com>" `
      com.lacledeslan.build-node=$BUILDNODE `
      org.label-schema.schema-version="1.0" `
      org.label-schema.url="https://github.com/LacledesLAN/README.1ST" `
      org.label-schema.vcs-ref=$SOURCE_COMMIT `
      org.label-schema.vendor="Laclede's LAN" `
      org.label-schema.description="Counter-Strike: Global Offensive Dedicated Server" `
      org.label-schema.vcs-url="https://github.com/LacledesLAN/gamesvr-csgo"

# Set up Enviornment
RUN useradd --home /app --gid root --system CSGO &&`
    mkdir -p /app/ll-tests &&`
    chown CSGO:root -R /app;

## CSGO is so large we can't reliably use multi-stage builds in docker cloud

# Copy cached build files (if any)
COPY ./build-cache /app

#Pull in SteamCMD
COPY --from=csgo-builder /app /app/steamcmd

# Copy files in from builder
COPY --from=csgo-builder /output /app
# Ownership shim until [github.com/moby/moby/pull/34263] makes it into Docker Cloud
RUN chown -R CSGO:root /app;

## Add in tests
COPY ./ll-tests /app/ll-tests

RUN chmod +rx /app/ll-tests/*.sh &&`
    chmod +rwx /app/ll-tests &&`
    chown CSGO:root -R /app/ll-tests;

USER CSGO

# Install CSGO
RUN echo $'\n\nDownloading Counter-Strike: Global Offensive via SteamCMD' &&`
        /app/steamcmd/steamcmd.sh `
            +login anonymous `
            +force_install_dir /app `
            +app_update 740 validate `
            +quit;

RUN echo $'\n\nLinking steamclient.so to prevent srcds_run errors' &&`
        mkdir --parents /app/.steam/sdk32 &&`
        ln -s /app/bin/steamclient.so /app/.steam/sdk32/steamclient.so;

WORKDIR /app

ONBUILD USER root
