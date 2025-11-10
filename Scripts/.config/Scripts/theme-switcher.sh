#!/usr/bin/env bash

THEME_DIR="$HOME/dotfiles/Themes"

CHOICE=$(echo -e "Dark\nLight" | rofi -dmenu -i -p "Select Theme:")
[ -z "$CHOICE" ] && exit

if [ "$CHOICE" == "Dark" ]; then
    THEME="$THEME_DIR/dark"
elif [ "$CHOICE" == "Light" ]; then
    THEME="$THEME_DIR/light"
else
    exit 1
fi

# Set wallpaper via hyprpaper
hyprpaper output "*" "$THEME/wallpaper.jpg"

# Kill current Waybar
pkill waybar

# Launch Waybar with selected style
WAYBAR_STYLE="$THEME/waybar.css" waybar &

# Optional: update EWW panel (if you use it)
# eww reload

echo "Theme switched to $CHOICE"
