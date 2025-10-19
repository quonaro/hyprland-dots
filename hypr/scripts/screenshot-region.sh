#!/bin/bash
# Screenshot selected region

SCREENSHOT_DIR="$HOME/Pictures/Screenshots"
mkdir -p "$SCREENSHOT_DIR"

FILE="$SCREENSHOT_DIR/screenshot_$(date +%Y%m%d_%H%M%S).png"

grim -g "$(slurp)" "$FILE"

if [ -f "$FILE" ]; then
    # Копируем в буфер обмена
    wl-copy < "$FILE" &
    
    notify-send "Скриншот области сохранён" "$FILE" -i "$FILE" -a "Screenshot" -t 3000 --action="default=Открыть" | while read action; do
        if [ "$action" = "default" ]; then
            xdg-open "$FILE"
        fi
    done &
fi

