#!/bin/bash

PROFILE_DIR="$1"
PROFILE_NAME="$2"

if [ -z "$PROFILE_DIR" ] || [ -z "$PROFILE_NAME" ]; then
  echo "Usage: import-wallpapers.sh <profile-dir> <profile-name>"
  exit 1
fi

WALLPAPER_SRC="$PROFILE_DIR/wallpapers"
WALLPAPER_DEST="$HOME/Pictures/Wallpapers/$PROFILE_NAME"
WALLPAPER_CONF="$WALLPAPER_SRC/wallpaper.conf"

echo "  [wallpapers] Installing wallpapers..."
mkdir -p "$WALLPAPER_DEST"
sudo cp -r "$WALLPAPER_SRC/." "$WALLPAPER_DEST/"

# Load picture-options from conf, default to 'zoom'
PICTURE_OPTIONS="zoom"
if [ -f "$WALLPAPER_CONF" ]; then
  source "$WALLPAPER_CONF"
fi

# Supported image formats (inclusive list, case-insensitive)
IMAGE_MATCH=( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png"
              -o -iname "*.webp" -o -iname "*.avif" -o -iname "*.bmp"
              -o -iname "*.gif" -o -iname "*.tiff" )

# Find light and dark wallpapers by naming convention (light.*, dark.*)
LIGHT=$(find "$WALLPAPER_DEST" -maxdepth 1 -iname "light.*" \( "${IMAGE_MATCH[@]}" \) | head -1)
DARK=$(find "$WALLPAPER_DEST"  -maxdepth 1 -iname "dark.*"  \( "${IMAGE_MATCH[@]}" \) | head -1)

# Fallback: if no light/dark naming found, use the first image in the folder for both
if [ -z "$LIGHT" ] && [ -z "$DARK" ]; then
  FALLBACK=$(find "$WALLPAPER_DEST" -maxdepth 1 \( "${IMAGE_MATCH[@]}" \) | head -1)
  if [ -n "$FALLBACK" ]; then
    echo "  [wallpapers] No light/dark naming found — using $(basename "$FALLBACK") for both themes."
    LIGHT="$FALLBACK"
    DARK="$FALLBACK"
  fi
fi

if [ -n "$LIGHT" ]; then
  echo "  [wallpapers] Setting light wallpaper ($(basename "$LIGHT"))..."
  gsettings set org.gnome.desktop.background picture-uri "file://$LIGHT"
else
  echo "  [wallpapers] No light wallpaper found in profile, skipping."
fi

if [ -n "$DARK" ]; then
  echo "  [wallpapers] Setting dark wallpaper ($(basename "$DARK"))..."
  gsettings set org.gnome.desktop.background picture-uri-dark "file://$DARK"
else
  echo "  [wallpapers] No dark wallpaper found in profile, skipping."
fi

gsettings set org.gnome.desktop.background picture-options "$PICTURE_OPTIONS"

echo "  [wallpapers] Done."
