#!/bin/bash
STATE_FILE="$HOME/.cache/current-kb-layout"
# Read the state file; default to "US" if it doesn't exist
cat "$STATE_FILE" 2>/dev/null || echo "US"
