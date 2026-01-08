#!/bin/bash

# Check if we are toggling the mode
if [ "$1" == "toggle" ]; then
  mode=$(makoctl mode | grep "dnd")
  if [ -n "$mode" ]; then
    makoctl mode -r dnd
  else
    makoctl mode -s dnd
  fi
fi

# Check the current mode to update the icon
mode=$(makoctl mode | grep "dnd")
if [ -n "$mode" ]; then
  # "alt": "dnd" tells Waybar to use the "dnd" icon from format-icons
  echo '{"text": "DnD", "alt": "dnd", "class": "dnd", "tooltip": "Do Not Disturb Active"}'
else
  # "alt": "default" tells Waybar to use the default icon
  echo '{"text": "", "alt": "default", "class": "default", "tooltip": "Notifications On"}'
fi
