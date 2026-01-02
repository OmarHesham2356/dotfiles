#!/bin/bash

# Get keyboard layouts from niri and find the active one (marked with '*')
active_layout=$(niri msg keyboard-layouts | grep -E '^\s*\*' | head -n1)

# Extract the layout name and convert to code
case "$active_layout" in
*"English (US)"*)
  echo "US"
  ;;
*"Arabic"*)
  echo "AR"
  ;;
*)
  # Fallback: if parsing fails, show a question mark
  echo "??"
  ;;
esac
