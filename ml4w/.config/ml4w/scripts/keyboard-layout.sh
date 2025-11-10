#!/bin/bash

# Get the active keymap name for the 'main: yes' keyboard
layout_name=$(hyprctl devices -j | jq -r '.keyboards[] | select(.main == true) | .active_keymap')

# Case statement to return the desired abbreviation
case "$layout_name" in
    "English (US)")
        echo "US"
        ;;
    "Arabic")
        echo "AR"
        ;;
    *)
        # Fallback for any other names
        echo "$layout_name"
        ;;
esac
