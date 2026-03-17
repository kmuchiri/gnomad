#!/bin/bash

PROFILE_DIR="$1"

if [ -z "$PROFILE_DIR" ]; then
  echo "Usage: export-workspace.sh <profile-dir>"
  exit 1
fi

mkdir -p "$PROFILE_DIR/workspace"

echo "  [workspace] Capturing keybindings..."
dconf dump /org/gnome/desktop/wm/keybindings/ > "$PROFILE_DIR/workspace/keybindings.dconf"

echo "  [workspace] Capturing custom shortcuts..."
dconf dump /org/gnome/settings-daemon/plugins/media-keys/> "$PROFILE_DIR/workspace/custom-shortcuts.dconf"

echo "  [workspace] Capturing mutter settings..."
dconf dump /org/gnome/mutter/ > "$PROFILE_DIR/workspace/mutter-settings.dconf"

echo "  [workspace] Capturing shell keybindings..."
dconf dump /org/gnome/shell/keybindings/ > "$PROFILE_DIR/workspace/shell-keybindings.dconf"

# Custom scripts from ~/custom-scripts/
CUSTOM_SCRIPTS_SRC="$HOME/custom-scripts"
if [ -d "$CUSTOM_SCRIPTS_SRC" ]; then
  echo "  [workspace] Capturing custom scripts..."
  mkdir -p "$PROFILE_DIR/workspace/custom-scripts"
  cp -r "$CUSTOM_SCRIPTS_SRC/." "$PROFILE_DIR/workspace/custom-scripts/"
else
  echo "  [workspace] No ~/custom-scripts/ found, skipping."
fi

# Workspace count and dynamic/fixed mode
echo "  [workspace] Capturing workspace count and mode..."
DYNAMIC=$(gsettings get org.gnome.mutter dynamic-workspaces)
NUM=$(gsettings get org.gnome.desktop.wm.preferences num-workspaces)
{
  echo "DYNAMIC_WORKSPACES=$DYNAMIC"
  echo "NUM_WORKSPACES=$NUM"
} > "$PROFILE_DIR/workspace/workspaces.conf"
echo "    dynamic: $DYNAMIC  |  num-workspaces: $NUM"

echo "  [workspace] Done."
