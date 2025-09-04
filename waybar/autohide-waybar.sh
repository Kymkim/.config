#!/bin/bash

WAYBAR_CMD="waybar"
WAYBAR_PIDFILE="/tmp/waybar.pid"

check_window() {
    CLIENTS=$(hyprctl activeworkspace -j | jq -r ".windows | length")
    FLOATS=$(hyprctl activewindow -j | jq -r ".floating")
    if [ "$CLIENTS" -gt 0 ]; then
        if [ "$FLOATS" == "true" ]; then
            return 1
        else
            return 0  # windows exist
        fi
    else
        return 1  # no windows
    fi
}

start_waybar() {
    # Check if PID file exists and process is alive
    if [ -f "$WAYBAR_PIDFILE" ] && kill -0 "$(cat "$WAYBAR_PIDFILE")" 2>/dev/null; then
        echo "Waybar already running, skipping start..."
        return
    fi

    # Check if any waybar process is running anyway
    if pgrep -x "waybar" >/dev/null; then
        echo "Waybar process already exists, updating PID file..."
        echo "$(pgrep -x waybar | head -n1)" > "$WAYBAR_PIDFILE"
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

# Main loop
while true; do
    if check_window; then
        stop_waybar
    else
        start_waybar
    fi
    sleep 1
done
