#!/bin/bash

export LC_NUMERIC=C

# CPU
cpu_usage=$(LC_NUMERIC=C top -bn1 | grep "Cpu(s)" | awk '{print $2}' | cut -d'%' -f1 | tr ',' '.')
cpu_freq=$(cat /proc/cpuinfo | grep "MHz" | head -n1 | LC_NUMERIC=C awk '{printf "%.1f", $4/1000}')

# Memory
mem_info=$(free -h | awk '/^Mem:/ {print $3 "/" $2}')
mem_percent=$(LC_NUMERIC=C free | awk '/^Mem:/ {printf "%.0f", $3/$2 * 100}')

# Storage
storage_info=$(df -h / | awk 'NR==2 {print $3 "/" $2}')
storage_percent=$(df / | awk 'NR==2 {print $5}' | sed 's/%//')

# Temperature
temp_file=$(find /sys/class/hwmon/ -name temp1_input 2>/dev/null | head -n1)
if [ -n "$temp_file" ] && [ -f "$temp_file" ]; then
    temp=$(cat "$temp_file" 2>/dev/null)
    temp_c=$((temp / 1000))
else
    temp_c="N/A"
fi

# Battery - disabled
battery_text=""
battery_percent=""
battery_status=""

# Format values (remove decimal part for display)
cpu_display=$(echo "$cpu_usage" | cut -d'.' -f1)
mem_display=$(echo "$mem_percent" | cut -d'.' -f1)

# Compact display text with better icons (skip temp if N/A)
if [ "$temp_c" = "N/A" ]; then
    text="󰻠 ${cpu_display}% │ 󰍛 ${mem_display}%"
else
    text="󰔏 ${temp_c}° │ 󰻠 ${cpu_display}% │ 󰍛 ${mem_display}%"
fi

# Detailed tooltip with improved formatting and icons
if [ "$temp_c" = "N/A" ]; then
    tooltip="󰻠 CPU: ${cpu_display}% @ ${cpu_freq}GHz\n󰍛 Memory: ${mem_info} (${mem_display}%)\n󰋊 Storage: ${storage_info} (${storage_percent}%)"
else
    tooltip="󰔏 Temperature: ${temp_c}°C\n󰻠 CPU: ${cpu_display}% @ ${cpu_freq}GHz\n󰍛 Memory: ${mem_info} (${mem_display}%)\n󰋊 Storage: ${storage_info} (${storage_percent}%)"
fi

# Output JSON
printf '{"text":"%s", "tooltip":"%s", "class":"system-info"}\n' "$text" "$tooltip"