
setup() {
    echo "Running CSGO for 45 seconds and capturing output"

    command="/app/srcds_run -game csgo +game_type 0 +game_mode 1 -tickrate 128 -console -usercon +map de_cache +sv_lan 1"
    log="/csgo-test.log"

    $command > "$log" 2>&1 &
    pid=$!
    sleep 45
    kill $pid
}

