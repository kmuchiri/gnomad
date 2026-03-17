#!/bin/bash

PROFILE_DIR="$1"

if [ -z "$PROFILE_DIR" ]; then
  echo "Usage: import-configs.sh <profile-dir>"
  exit 1
fi

CONFIGS_DIR="$PROFILE_DIR/configs"

echo "  [configs] Applying configs..."

# Kitty terminal
if [ -d "$CONFIGS_DIR/kitty" ]; then
  echo "  [configs] Copying kitty config..."
  mkdir -p "$HOME/.config/kitty"
  cp -r "$CONFIGS_DIR/kitty/." "$HOME/.config/kitty/"
else
  echo "  [configs] No kitty config found in profile, skipping."
fi

echo "  [configs] Done."
