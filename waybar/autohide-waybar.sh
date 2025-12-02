#!/bin/bash

WAYBAR_CMD="waybar -c /home/$USER/.config/waybar/leftbar"
TOPBAR_CMD="waybar -c /home/$USER/.config/waybar/topbar"
WAYBAR_PIDFILE="/tmp/waybar.pid"
TOPBAR_PIDFILE="/tmp/topbar.pid"

TICK=0

check_window() {
    CLIENTS=$(hyprctl activeworkspace -j | jq -r ".windows | length")
    FLOATS=$(hyprctl activewindow -j | jq -r ".floating")
    if [ "$CLIENTS" == 1 ] && [ "$FLOATS" == "true" ]; then
        return 1
    fi
    if [ "$CLIENTS" -gt 0 ]; then
        return 0  # windows exist
    else
        return 1  # no windows
    fi
}

start_waybar() {
    if [ -f "$WAYBAR_PIDFILE" ] && kill -0 "$(cat "$WAYBAR_PIDFILE")" 2>/dev/null; then
        echo "Waybar already running"
        return
    fi
    if pgrep -f "$WAYBAR_CMD" >/dev/null; then
        echo "$(pgrep -f "$WAYBAR_CMD" | head -n1)" > "$WAYBAR_PIDFILE"
        return
    fi
    echo "Starting Waybar..."
    $WAYBAR_CMD &
    echo $! > "$WAYBAR_PIDFILE"
}

stop_waybar() {
    if [ -f "$WAYBAR_PIDFILE" ]; then
        PID=$(cat "$WAYBAR_PIDFILE")
        if kill -0 "$PID" 2>/dev/null; then
            echo "Stopping Waybar..."
            kill "$PID"
        fi
        rm -f "$WAYBAR_PIDFILE"
    fi
}

start_topbar() {
    if [ -f "$TOPBAR_PIDFILE" ] && kill -0 "$(cat "$TOPBAR_PIDFILE")" 2>/dev/null; then
        echo "Topbar already running"
        return
    fi
    if pgrep -f "$TOPBAR_CMD" >/dev/null; then
        echo "$(pgrep -f "$TOPBAR_CMD" | head -n1)" > "$TOPBAR_PIDFILE"
        return
    fi
    echo "Starting Topbar..."
    $TOPBAR_CMD &
    echo $! > "$TOPBAR_PIDFILE"
}

stop_topbar() {
    if [ -f "$TOPBAR_PIDFILE" ]; then
        PID=$(cat "$TOPBAR_PIDFILE")
        if kill -0 "$PID" 2>/dev/null; then
            echo "Stopping Topbar..."
            kill "$PID"
        fi
        rm -f "$TOPBAR_PIDFILE"
    fi
}

while true; do
    if check_window; then
        stop_waybar
        # ((TICK++))
        # if [ "$TICK" -gt 3 ]; then
        #     start_topbar
        # fi
    else
        start_waybar
        # stop_topbar
        # TICK=0
    fi
    sleep 1
done
