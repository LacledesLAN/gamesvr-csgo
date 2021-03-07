# Optional SteamCMD Cache

This folder can be used to cache SteamCMD downloads prior to executing `docker build`. This speeds up builds on slow Internet connections but slows down builds on fast connections. Your mileage will vary.

## Disabling SteamCMD Downloads

If you anticipate having to do emergency builds when Internet bandwidth is at a premium disabling SteamCMD downloads and relying on an already-built cache *could* be a lifesaver. Just provide the argument of `--build-arg SKIP_STEAMCMD=true` when building the image.

## Build the Cache

To populate the cache install the relevant game server data into this directory using [SteamCMD](https://developer.valvesoftware.com/wiki/SteamCMD). If you are using [VSCode](https://code.visualstudio.com/) a task is already defined otherwise you can use [Laclede's LAN SteamCMD Docker](https://github.com/LacledesLAN/SteamCMD) image:

```shell
docker run -i --rm -v ./.steamcmd-cache/linux:/output lacledeslan/steamcmd:linux ./steamcmd.sh +login anonymous +force_install_dir /output +app_update <XXX> validate +quit
```

> Replace `XXX` with the correct [Steam CMD Application ID](https://developer.valvesoftware.com/wiki/Dedicated_Servers_List).
