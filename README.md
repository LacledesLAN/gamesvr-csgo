# Counter-Strike: Global Offensive Dedicated Server in Docker

## Linux

[![](https://images.microbadger.com/badges/version/lacledeslan/gamesvr-csgo.svg)](https://microbadger.com/images/lacledeslan/gamesvr-csgo "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/lacledeslan/gamesvr-csgo.svg)](https://microbadger.com/images/lacledeslan/gamesvr-csgo "Get your own image badge on microbadger.com")

**Download**
```
docker pull lacledeslan/gamesvr-csgo
```

**Run Interactive Server**
```
docker run -it --rm --net=host lacledeslan/gamesvr-csgo ./srcds_run -game csgo +game_type 0 +game_mode 1 -tickrate 128 -console -usercon +map de_cache +sv_lan 1
```

**Run Self Tests**
```
docker run -it --rm lacledeslan/gamesvr-csgo ./ll-tests/gamesvr-csgo.sh
```
