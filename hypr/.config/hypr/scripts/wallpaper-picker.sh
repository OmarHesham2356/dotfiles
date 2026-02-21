#!/bin/bash

# 1. Open File Explorer
FILE=$(zenity --file-selection --filename="$HOME/Pictures/wallpaper/" --title="Select Wallpaper" --file-filter="Images | *.jpg *.jpeg *.png *.webp")

# 2. Check cancellation
if [ -z "$FILE" ]; then
  exit 0
fi

# 3. Apply Wallpaper (swww)
swww img "$FILE" --transition-type grow --transition-fps 60 --transition-duration 2

# 4. Save Copy for Hyprlock
cp "$FILE" ~/.config/hypr/current_wallpaper.jpg

# --- FIX IS HERE: Changed .j to .jpg ---
magick "$FILE" -resize x500 -strip ~/.config/rofi/cached_wallpaper.png

# 5. Generate Colors
ghostty --title "Matugen Color Picker" --class "floating" -e bash -c "matugen image -v '$FILE' ; sleep 1" && notify-send "Theme Updated" "Colors applied."
