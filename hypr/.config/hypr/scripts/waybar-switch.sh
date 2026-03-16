#!/bin/bash

# Define options with icons
OPTIONS="🏝️ Dynamic Island
💊 Classic Bar
➖ Minimal Line
"

# Open Rofi menu
CHOICE=$(echo -e "$OPTIONS" | rofi -dmenu -theme ~/.config/rofi/config.rasi -p "Waybar Layout")

# Paths
LAYOUT_DIR="$HOME/.config/waybar/layouts"
CONFIGS_DIR="$HOME/.config/waybar/configs"
TARGET_DIR="$HOME/.config/waybar"

case "$CHOICE" in
"🏝️ Dynamic Island")
  ln -sf "$LAYOUT_DIR/island/config.jsonc" "$TARGET_DIR/config.jsonc"
  ln -sf "$LAYOUT_DIR/island/style.css" "$TARGET_DIR/style.css"
  notify-send "Waybar" "Switched to Dynamic Island"
  ;;
"💊 Classic Bar")
  ln -sf "$LAYOUT_DIR/classic/config.jsonc" "$TARGET_DIR/config.jsonc"
  ln -sf "$LAYOUT_DIR/classic/style.css" "$TARGET_DIR/style.css"
  notify-send "Waybar" "Switched to Classic Layout"
  ;;
"➖ Minimal Line")
  ln -sf "$LAYOUT_DIR/minimal/config.jsonc" "$TARGET_DIR/config.jsonc"
  ln -sf "$LAYOUT_DIR/minimal/style.css" "$TARGET_DIR/style.css"
  notify-send "Waybar" "Switched to Minimal Layout"
  ;;
*)
  exit 1
  ;;
esac

# Restart Waybar to apply changes
killall waybar
waybar &
