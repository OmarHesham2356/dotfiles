#!/bin/bash

# Count the number of lines (items) in the cliphist list
LINES=$(cliphist list | wc -l)

if [[ $LINES -eq 0 ]]; then
    # Return "empty" to use the empty icon
    ICON_STATUS='empty'
else
    # Return "full" to use the full icon
    ICON_STATUS='full'
fi

# Output JSON for Waybar to parse, using 'alt' to map to format-icons
jq --unbuffered --compact-output \
    --arg icon "$ICON_STATUS" \
    --arg items "$LINES item(s)" \
    -n '{"alt": $icon, "tooltip": $items}'

