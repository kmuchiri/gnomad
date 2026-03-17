#!/bin/bash

PROFILE_DIR="$1"

if [ -z "$PROFILE_DIR" ]; then
  echo "Usage: export-configs.sh <profile-dir>"
  exit 1
fi

mkdir -p "$PROFILE_DIR/configs"

echo "  [configs] Capturing app configs..."

# Kitty terminal
if [ -d "$HOME/.config/kitty" ]; then
  echo "  [configs] Copying kitty config..."
  mkdir -p "$PROFILE_DIR/configs/kitty"
  cp -r "$HOME/.config/kitty/." "$PROFILE_DIR/configs/kitty/"
else
  echo "  [configs] Kitty config not found at ~/.config/kitty, skipping."
fi

echo "  [configs] Done."
