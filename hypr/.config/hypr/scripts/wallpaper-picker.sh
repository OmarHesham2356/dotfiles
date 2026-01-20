#!/bin/bash

# 1. Open the File Explorer (Zenity) pointed at your wallpaper folder
#    Change ~/Pictures/wallpaper/ to your actual folder path
FILE=$(zenity --file-selection --filename="$HOME/Pictures/wallpaper/" --title="Select Wallpaper" --file-filter="Images | *.jpg *.jpeg *.png *.webp")

# 2. Check if the user canceled (pressed Esc or Cancel)
if [ -z "$FILE" ]; then
  exit 0
fi

# 3. Apply the Wallpaper (using swww)
swww img "$FILE" --transition-type grow --transition-fps 60 --transition-duration 2

# 4. SAVE COPY FOR HYPRLOCK (This is the magic line)
cp "$FILE" ~/.config/hypr/current_wallpaper.jpg

# 5. Generate Colors (using matugen)
#    We run this in the background & send a notification when done
matugen image "$FILE" && notify-send "Theme Updated" "Colors generated from $(basename "$FILE")"
