#!/bin/bash

# Get brightness value
BRIGHTNESS=$(brightnessctl get)
MAX_BRIGHTNESS=$(brightnessctl max)
PERCENT=$(( BRIGHTNESS * 100 / MAX_BRIGHTNESS ))

# Choose icon based on brightness level
if [ "$PERCENT" -ge 80 ]; then
    ICON="󰃠"  # full brightness
elif [ "$PERCENT" -ge 30 ]; then
    ICON="󰃝"  # medium brightness
else
    ICON="󰃞"  # low brightness
fi

# Output JSON for Waybar
echo "{\"text\": \"$PERCENT\", \"alt\": \"$ICON\", \"tooltip\": \"Brightness: $PERCENT%\", \"class\": \"brightness\", \"percentage\": $PERCENT, \"icon\": \"$ICON\"}"
