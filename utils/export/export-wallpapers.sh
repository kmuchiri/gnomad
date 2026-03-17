#!/bin/bash

PROFILE_DIR="$1"

if [ -z "$PROFILE_DIR" ]; then
  echo "Usage: export-wallpapers.sh <profile-dir>"
  exit 1
fi

mkdir -p "$PROFILE_DIR/wallpapers"

echo "  [wallpapers] Reading current wallpaper settings..."

# Read current wallpaper paths — strip surrounding quotes and file:// prefix
LIGHT_URI=$(gsettings get org.gnome.desktop.background picture-uri | tr -d "'" | sed 's|file://||')
DARK_URI=$(gsettings get org.gnome.desktop.background picture-uri-dark | tr -d "'" | sed 's|file://||')
OPTIONS=$(gsettings get org.gnome.desktop.background picture-options | tr -d "'")

if [ -f "$LIGHT_URI" ]; then
  EXT="${LIGHT_URI##*.}"
  cp "$LIGHT_URI" "$PROFILE_DIR/wallpapers/light.$EXT"
  echo "  [wallpapers] Copied light wallpaper."
else
  echo "  [wallpapers] Warning: light wallpaper not found at $LIGHT_URI"
fi

if [ -f "$DARK_URI" ]; then
  EXT="${DARK_URI##*.}"
  cp "$DARK_URI" "$PROFILE_DIR/wallpapers/dark.$EXT"
  echo "  [wallpapers] Copied dark wallpaper."
else
  echo "  [wallpapers] Warning: dark wallpaper not found at $DARK_URI"
fi

# Save picture-options setting
cat > "$PROFILE_DIR/wallpapers/wallpaper.conf" << EOF
PICTURE_OPTIONS=$OPTIONS
EOF

echo "  [wallpapers] Done."
