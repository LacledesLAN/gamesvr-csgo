# Counter-Strike: Global Offensive Dedicated Server in Docker

Counter-Strike: Global Offensive (CS:GO) is a multiplayer first-person shooter and is the fourth game in the [Counter-Strike series](https://en.wikipedia.org/wiki/Counter-Strike). The game pits two teams against each other: the Terrorists and the Counter-Terrorists. Both sides are tasked with eliminating the other while also completing separate objectives, the Terrorists, depending on the game mode, must either plant the bomb or defend the hostages, while the Counter-Terrorists must either prevent the bomb from being planted, defuse the bomb, or rescue the hostages. There are eight game modes, all of which have distinct characteristics specific to that mode.

![Counter-Strike Global Offensive Screenshot](https://raw.githubusercontent.com/LacledesLAN/gamesvr-csgo/master/.misc/screenshot.jpg "Counter-Strike Global Offensive Screenshot")

This repository is maintained by [Laclede's LAN](https://lacledeslan.com). Its contents are intended to be bare-bones and used as a stock server. For examples of building a customized server from this Docker image browse its related child-projects [gamesvr-csgo-freeplay](https://github.com/LacledesLAN/gamesvr-csgo-freeplay), [gamesvr-csgo-test](https://github.com/LacledesLAN/gamesvr-csgo-test), and [gamesvr-csgo-tourney](https://github.com/LacledesLAN/gamesvr-csgo-tourney). If any documentation is unclear or it has any issues please see [CONTRIBUTING.md](./CONTRIBUTING.md).

## Linux

### Download

```shell
docker pull lacledeslan/gamesvr-csgo;
```

### Run Self Tests

The image includes a test script that can be used to verify its contents. No changes or pull-requests will be accepted to this repository if any tests fail.

```shell
docker run -it --rm lacledeslan/gamesvr-csgo ./ll-tests/gamesvr-csgo.sh;
```

### Run Interactive Server

```shell
docker run -it --rm --net=host lacledeslan/gamesvr-csgo ./srcds_run -game csgo +game_type 0 +game_mode 1 -tickrate 128 +map de_cache +sv_lan 1;
```

## Getting Started with Game Servers in Docker

[Docker](https://docs.docker.com/) is an open-source project that bundles applications into lightweight, portable, self-sufficient containers. For a crash course on running Dockerized game servers check out [Using Docker for Game Servers](https://github.com/LacledesLAN/README.1ST/blob/master/GameServers/DockerAndGameServers.md). For tips, tricks, and recommended tools for working with Laclede's LAN Dockerized game server repos see the guide for [Working with our Game Server Repos](https://github.com/LacledesLAN/README.1ST/blob/master/GameServers/WorkingWithOurRepos.md). You can also browse all of our other Dockerized game servers: [Laclede's LAN Game Servers Directory](https://github.com/LacledesLAN/README.1ST/tree/master/GameServers).
