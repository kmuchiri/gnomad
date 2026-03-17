#!/bin/bash

PROFILE_DIR="$1"

if [ -z "$PROFILE_DIR" ]; then
  echo "Usage: import-workspace.sh <profile-dir>"
  exit 1
fi

WORKSPACE_DIR="$PROFILE_DIR/workspace"

echo "  [workspace] Applying workspace settings..."

# Step 1: Clear Super+num dock shortcuts FIRST so they can be claimed by workspace switcher
if [ -f "$WORKSPACE_DIR/shell-keybindings.dconf" ]; then
  echo "  [workspace] Clearing shell keybindings (dock shortcuts)..."
  dconf load /org/gnome/shell/keybindings/ < "$WORKSPACE_DIR/shell-keybindings.dconf"
else
  echo "  [workspace] No shell-keybindings.dconf found, skipping."
fi

# Step 2: Now apply WM keybindings (Super+num → workspace switching)
if [ -f "$WORKSPACE_DIR/keybindings.dconf" ]; then
  echo "  [workspace] Loading keybindings..."
  dconf load /org/gnome/desktop/wm/keybindings/ < "$WORKSPACE_DIR/keybindings.dconf"
else
  echo "  [workspace] No keybindings.dconf found, skipping."
fi

# Step 3: Custom app shortcuts
if [ -f "$PROFILE_DIR/workspace/custom-shortcuts.dconf" ]; then
  echo "  [workspace] Loading custom shortcuts..."
  dconf load /org/gnome/settings-daemon/plugins/media-keys/ < "$PROFILE_DIR/workspace/custom-shortcuts.dconf"
else
  echo "  [workspace] No custom-shortcuts.dconf found, skipping."
fi

# Step 4: Mutter settings (dynamic workspaces, auto-maximize, etc.)
if [ -f "$WORKSPACE_DIR/mutter-settings.dconf" ]; then
  echo "  [workspace] Loading mutter settings..."
  dconf load /org/gnome/mutter/ < "$WORKSPACE_DIR/mutter-settings.dconf"
else
  echo "  [workspace] No mutter-settings.dconf found, skipping."
fi

# Custom scripts
CUSTOM_SCRIPTS="$WORKSPACE_DIR/custom-scripts"
if [ -d "$CUSTOM_SCRIPTS" ]; then
  echo "  [workspace] Installing custom scripts to ~/custom-scripts/..."
  mkdir -p "$HOME/custom-scripts"
  cp -r "$CUSTOM_SCRIPTS/." "$HOME/custom-scripts/"
  chmod +x "$HOME/custom-scripts/"*.sh 2>/dev/null || true
else
  echo "  [workspace] No custom-scripts found in profile, skipping."
fi

# Workspace count and dynamic/fixed mode
if [ -f "$WORKSPACE_DIR/workspaces.conf" ]; then
  echo "  [workspace] Restoring workspace count and mode..."
  # shellcheck source=/dev/null
  source "$WORKSPACE_DIR/workspaces.conf"

  if [ -n "$DYNAMIC_WORKSPACES" ]; then
    gsettings set org.gnome.mutter dynamic-workspaces "$DYNAMIC_WORKSPACES"
    echo "    dynamic-workspaces: $DYNAMIC_WORKSPACES"
  fi

  if [ -n "$NUM_WORKSPACES" ]; then
    gsettings set org.gnome.desktop.wm.preferences num-workspaces "$NUM_WORKSPACES"
    echo "    num-workspaces: $NUM_WORKSPACES"
  fi
else
  echo "  [workspace] No workspaces.conf found, skipping."
fi

echo "  [workspace] Done."
