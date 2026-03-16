#!/bin/bash

WALLPAPER_DIR="$HOME/Pictures/wallpaper"

# 1. Generate the list of wallpapers and format them for Rofi
SELECTED=$(
  for file in "$WALLPAPER_DIR"/*.{jpg,jpeg,png,webp}; do
    [ -e "$file" ] || continue
    filename=$(basename "$file")
    echo -en "${filename}\0icon\x1f${file}\n"
  done | rofi -dmenu \
    -show-icons \
    -theme ~/.config/rofi/wallpaper.rasi \
    -p " "
)

# 2. Check cancellation
if [ -z "$SELECTED" ]; then
  exit 0
fi

FILE="$WALLPAPER_DIR/$SELECTED"

# 3. Apply Wallpaper (swww)
swww img "$FILE" --transition-type grow --transition-fps 60 --transition-duration 2

# 4. Save Copy for Hyprlock
cp "$FILE" ~/.config/hypr/current_wallpaper.jpg

# --- Cache the new image for the Rofi app launcher sidebar ---
magick "$FILE" -resize x500 -strip ~/.config/rofi/cached_wallpaper.png

# 5. Generate Colors
matugen image "$FILE" && notify-send "Theme Updated" "Colors generated from $(basename "$FILE")"
