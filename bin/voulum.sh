#!/bin/sh
arg=$1

case "$arg" in
    up)
        pactl set-sink-volume @DEFAULT_SINK@ +5%
        ;;
    down)
        pactl set-sink-volume @DEFAULT_SINK@ -5%
        ;;
    toggle)
        pactl set-sink-mute @DEFAULT_SINK@ toggle
        ;;
    *)
        echo "Usage: $0 {up|down|toggle}"
        exit 1
        ;;
esac

# Send signal to dwmblocks or slstatus to update the bar
pkill -RTMIN+30 dwmblocks
