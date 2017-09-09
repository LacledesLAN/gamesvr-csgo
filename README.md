# Counter-Strike: Global Offensive Server in Docker

## Linux

[![](https://images.microbadger.com/badges/version/lacledeslan/gamesvr-csgo.svg)](https://microbadger.com/images/lacledeslan/gamesvr-csgo "Get your own version badge on microbadger.com")
[![](https://images.microbadger.com/badges/image/lacledeslan/gamesvr-csgo.svg)](https://microbadger.com/images/lacledeslan/gamesvr-csgo "Get your own image badge on microbadger.com")

**Download**
```
docker pull lacledeslan/gamesvr-csgo
```

**Run self tests**
```
docker run -it --rm lacledeslan/gamesvr-csgo ./ll-tests/gamesvr-csgo.sh
```

**Run simple interactive server**
```
docker run -it --rm --net=host lacledeslan/gamesvr-csgo ./srcds_run -game csgo +game_type 0 +game_mode 1 -tickrate 128 -console -usercon +map de_cache +sv_lan 1
```

## Build Triggers
Automated builds of this image can be triggered by the following sources:
* [Builds of llgameserverbot/csgo-watcher](https://hub.docker.com/r/llgameserverbot/csgo-watcher/)
* [Commits to GitHub repository](https://github.com/LacledesLAN/gamesvr-csgo)

## Tournament Flow via [Warmod [BFG]](https://forums.alliedmods.net/showthread.php?t=225474)

Server starts in *warm up* mode where players can toggle themselves as "/ready". Once all ten players are ready *knife mode* begins.

Last player standing at the end of *knife mode* gets to decide which side to start on (CT or T) by typing either "stay" or "switch".

Another *warm up* mode begins; once all players are ready "live on three" runs and live play begins.

Half-time starts after 15 rounds and lasts 30 seconds. Players sides are swapped.

At the end scoreboard shows and server freezes.

## Client Checks
The following checks can be preformed from a connected csgo client

#### Verify LL Config is Loaded

Press `y` to open game chat. Text "LL-Server" should be displayed.

#### Verify Metamod and SourceMod are Working

Press `y` to open game chat; then type `!sm_admin`. Either the text "you do not have access to this command" should be displayed or a menu should pop up.

#### Verify WarMod [BFG] is Loaded

Press `y` to open game chat and enter `/info`. Warmod should be listed in the output.

## Useful Warmod [BFG] Commands

#### CLIENT Commands
* `/info` - Displays who's ready if panel was closed (warmup mode only)
* `/ready` - Marks you as ready (warmup mode only)
* `/scores` - Display scores (live play only)
* `/unready` - Marks you as unready (warmup mode only)

#### Admin Commands
* `/forceallready` - Forces all players to become ready.
* `/forceallunready` - Forces all players to become unready.
* `/forcestart` - Starts the match regardless of player and ready count.
* `/forceend` - Ends the match regardless of status.
* `/minready` - Set or display the wm_min_ready console variable.
* `/maxrounds <num>` - Set or display the wm_max_rounds console variable
* `/aswap` - Manually swaps all players to the opposite team
* `/t` & `/ct` - Set the Terrorist and Counter-Terrorist team names (note: doesn't change the the cvars *wm_t* or *wm_ct*).
