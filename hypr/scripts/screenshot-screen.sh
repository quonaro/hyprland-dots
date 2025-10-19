#!/bin/bash
# Screenshot full screen

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

FILE="$SCREENSHOT_DIR/screenshot_$(date +%Y%m%d_%H%M%S).png"

grim "$FILE"

# Копируем в буфер обмена
wl-copy < "$FILE" &

notify-send "Скриншот экрана сохранён" "$FILE" -i "$FILE" -a "Screenshot" -t 3000 --action="default=Открыть" | while read action; do
    if [ "$action" = "default" ]; then
        xdg-open "$FILE"
    fi
done &

