#!/bin/bash

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
PROFILE_DIR="$1"

if [ -z "$PROFILE_DIR" ]; then
  echo "Usage: import-extensions.sh <profile-dir>"
  exit 1
fi

source "$ROOT_DIR/utils/utils.sh"

EXT_LIST="$PROFILE_DIR/extensions/ext-list.txt"
SETTINGS_DCONF="$PROFILE_DIR/extensions/settings.dconf"

echo "  [extensions] Installing dependencies..."
install_packages "$PKG_PIPX" "$PKG_GNOME_EXTENSIONS"

if ! command -v ~/.local/bin/gext &> /dev/null; then
  pipx install gnome-extensions-cli --system-site-packages
fi

if [ -f "$EXT_LIST" ]; then
  echo "  [extensions] Installing extensions..."
  while IFS= read -r ext || [ -n "$ext" ]; do
    [ -z "$ext" ] && continue
    if ! ~/.local/bin/gext list | grep -q "$ext"; then
      echo "  [extensions] Installing: $ext"
      ~/.local/bin/gext install "$ext" --yes
    else
      echo "  [extensions] Already installed: $ext"
    fi
  done < "$EXT_LIST"
else
  echo "  [extensions] No ext-list.txt found in profile, skipping."
fi

if [ -f "$SETTINGS_DCONF" ]; then
  echo "  [extensions] Loading extension settings..."
  dconf load /org/gnome/shell/extensions/ < "$SETTINGS_DCONF"
else
  echo "  [extensions] No settings.dconf found in profile, skipping."
fi

echo "  [extensions] Done."
