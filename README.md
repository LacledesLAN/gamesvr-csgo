# Counter-Strike: Global Offensive Server in Docker

[![](https://images.microbadger.com/badges/version/lacledeslan/gamesvr-csgo.svg)](https://microbadger.com/images/lacledeslan/gamesvr-csgo "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/lacledeslan/gamesvr-csgo.svg)](https://microbadger.com/images/lacledeslan/gamesvr-csgo "Get your own image badge on microbadger.com")

## Usage

**Download:** `docker pull lacledeslan/gamesvr-csgo`

**Run simple interactive server**
```
docker run -it --net=host lacledeslan/gamesvr-csgo ./srcds_run -game csgo +game_type 0 +game_mode 1 -tickrate 128 -console -usercon +map de_cache +sv_lan 1
```

## Build Triggers
Automated builds of this image can be triggered by the following sources:
* [Commits on GitHub](https://github.com/LacledesLAN/gamesvr-csgo)
* [Builds of llgameserverbot/csgo-watcher](https://hub.docker.com/r/llgameserverbot/csgo-watcher/)
