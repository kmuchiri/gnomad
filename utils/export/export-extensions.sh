#!/bin/bash

PROFILE_DIR="$1"

if [ -z "$PROFILE_DIR" ]; then
  echo "Usage: export-extensions.sh <profile-dir>"
  exit 1
fi

mkdir -p "$PROFILE_DIR/extensions"

echo "  [extensions] Capturing installed extensions..."
gnome-extensions list --enabled > "$PROFILE_DIR/extensions/ext-list.txt"

echo "  [extensions] Capturing extension settings..."
dconf dump /org/gnome/shell/extensions/ > "$PROFILE_DIR/extensions/settings.dconf"

echo "  [extensions] Done."
