#!/bin/bash
# Screenshot active window

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

FILE="$SCREENSHOT_DIR/screenshot_$(date +%Y%m%d_%H%M%S).png"

# Get active window geometry
GEOMETRY=$(hyprctl activewindow -j | jq -r '"\(.at[0]),\(.at[1]) \(.size[0])x\(.size[1])"')

grim -g "$GEOMETRY" "$FILE"

# Копируем в буфер обмена
wl-copy < "$FILE" &

notify-send "Скриншот окна сохранён" "$FILE" -i "$FILE" -a "Screenshot" -t 3000 --action="default=Открыть" | while read action; do
    if [ "$action" = "default" ]; then
        xdg-open "$FILE"
    fi
done &

