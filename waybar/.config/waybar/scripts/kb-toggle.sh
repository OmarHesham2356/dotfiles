#!/bin/bash
STATE_FILE="$HOME/.cache/current-kb-layout"
current=$(cat "$STATE_FILE" 2>/dev/null || echo "US")
if [ "$current" = "US" ]; then
  echo "AR" >"$STATE_FILE"
else
  echo "US" >"$STATE_FILE"
fi
# Send a signal to Waybar to refresh immediately
pkill -RTMIN+11 waybar
