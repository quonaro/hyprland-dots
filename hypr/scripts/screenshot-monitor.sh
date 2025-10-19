#!/bin/bash
# Screenshot active monitor

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

FILE="$SCREENSHOT_DIR/screenshot_$(date +%Y%m%d_%H%M%S).png"

# Get active monitor name
MONITOR=$(hyprctl activeworkspace -j | jq -r '.monitor')

# Take screenshot of active monitor
grim -o "$MONITOR" "$FILE"

# Копируем в буфер обмена
wl-copy < "$FILE" &

notify-send "Скриншот монитора сохранён" "$FILE" -i "$FILE" -a "Screenshot" -t 3000 --action="default=Открыть" | while read action; do
    if [ "$action" = "default" ]; then
        xdg-open "$FILE"
    fi
done &

