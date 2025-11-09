#!/usr/bin/env bash
# sidebar.sh - shows a music control panel

# Get current song info using playerctl
song=$(playerctl metadata --format '{{ artist }} - {{ title }}' 2>/dev/null)
status=$(playerctl status 2>/dev/null)

# Set icons
if [ "$status" == "Playing" ]; then
    icon=""  # play
elif [ "$status" == "Paused" ]; then
    icon=""  # pause
else
    icon=""  # stop / nothing playing
fi

# Show menu with rofi (or wofi)
CHOICE=$(echo -e "  $song\n\n Play\n Pause\n Next\n Previous\n Close" | rofi -dmenu -p "Music" -width 30 -lines 6)

case "$CHOICE" in
    " Play") playerctl play ;;
    " Pause") playerctl pause ;;
    " Next") playerctl next ;;
    " Previous") playerctl previous ;;
    " Close") exit 0 ;;
esac

