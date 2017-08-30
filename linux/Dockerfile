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
FROM debian:stretch-slim

HEALTHCHECK NONE

ARG BUILDNODE="unspecified"
ARG SOURCE_COMMIT

LABEL maintainer="Laclede's LAN <contact @lacledeslan.com>" `
      com.lacledeslan.build-node=$BUILDNODE `
      org.label-schema.schema-version="1.0" `
      org.label-schema.url="https://github.com/LacledesLAN/README.1ST" `
      org.label-schema.vcs-ref=$SOURCE_COMMIT `
      org.label-schema.vendor="Laclede's LAN" `
      org.label-schema.description="Counter-Strike: Global Offensive in Docker" `
      org.label-schema.vcs-url="https://github.com/LacledesLAN/gamesvr-csgo"

RUN dpkg --add-architecture i386 &&`
    apt-get update && apt-get install -y `
        ca-certificates lib32gcc1 lib32tinfo5 libcurl3-gnutls libstdc++6 libstdc++6:i386 &&`
    apt-get clean &&`
    rm -rf /var/lib/apt/lists/*;

## CSGO is so large we can't reliably use multi-stage builds in docker cloud

# Copy files in from builder
COPY --from=csgo-builder /output /app

# Copy cached build files (if any)
COPY ./build-cache /app

#Pull in SteamCMD
COPY --from=csgo-builder /app /app/steamcmd

# Install CSGO
RUN echo $'\n\nDownloading Counter-Strike: Global Offensive via SteamCMD' &&`
        /app/steamcmd/steamcmd.sh `
            +login anonymous `
            +force_install_dir /app `
            +app_update 740 validate `
            +quit;

RUN echo $'\n\nLinking steamclient.so to prevent srcds_run errors' &&`
        mkdir --parents /app/.steam/sdk32 &&`
        ln -s /app/bin/steamclient.so /app/.steam/sdk32/steamclient.so

## Add in tests
COPY ./tests /app/ll-tests

RUN echo $'\n\nCreating user "CSGO" (to group "root" until [github.com/moby/moby/pull/34263] makes it into CE stable)' &&`
        useradd --home /app --gid root --system `
            CSGO &&`
    echo 'Setting user directory permissions' &&`
        chown CSGO:root /app &&`
        find /app -type d -exec chmod 775 {} + &&`
        chmod +x /app/ll-tests/*.sh

# Intentionally set after all build steps
USER CSGO

WORKDIR /app

ONBUILD USER root
