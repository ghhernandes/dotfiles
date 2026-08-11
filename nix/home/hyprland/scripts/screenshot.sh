#!/usr/bin/env bash

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
TIMESTAMP=$(date +"%Y%m%d_%H%M%S")
FILENAME="screenshot_${TIMESTAMP}.png"
FILEPATH="${SCREENSHOT_DIR}/${FILENAME}"

mkdir -p "$SCREENSHOT_DIR"

MODE="${1:-full}"

case "$MODE" in
    full)
        grim "$FILEPATH"
        ;;

    region)
        grim -g "$(slurp)" "$FILEPATH"
        ;;

    clipboard)
        grim -g "$(slurp)" - | wl-copy
        ;;

    window)
        grim -g "$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')" "$FILEPATH"
        ;;
esac
