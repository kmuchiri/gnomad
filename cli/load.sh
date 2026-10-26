#!/bin/bash

PROFILE_NAME="$1"

if [ -z "$PROFILE_NAME" ]; then
  echo "Usage: gnomad load <profile-name>"
  exit 1
fi

GNOMAD_LIB_DIR="${GNOMAD_LIB_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
GNOMAD_DATA_DIR="${GNOMAD_DATA_DIR:-$GNOMAD_LIB_DIR}"
GNOMAD_USER_PROFILES_DIR="${GNOMAD_USER_PROFILES_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/gnomad/profiles}"

# Search priority:
# 1. User profiles directory (~/.local/share/gnomad/profiles)
# 2. Built-in profiles directory ($GNOMAD_DATA_DIR/builtin-profiles or $GNOMAD_DATA_DIR/profiles)
# 3. Direct path (if profile argument is an existing directory)
if [ -d "$GNOMAD_USER_PROFILES_DIR/$PROFILE_NAME" ]; then
  PROFILE_DIR="$GNOMAD_USER_PROFILES_DIR/$PROFILE_NAME"
elif [ -d "$GNOMAD_DATA_DIR/builtin-profiles/$PROFILE_NAME" ]; then
  PROFILE_DIR="$GNOMAD_DATA_DIR/builtin-profiles/$PROFILE_NAME"
elif [ -d "$GNOMAD_DATA_DIR/profiles/$PROFILE_NAME" ]; then
  PROFILE_DIR="$GNOMAD_DATA_DIR/profiles/$PROFILE_NAME"
elif [ -d "$PROFILE_NAME" ]; then
  PROFILE_DIR="$(cd "$PROFILE_NAME" && pwd)"
else
  echo "Error: Profile '$PROFILE_NAME' not found."
  echo "Run 'gnomad list' to see available profiles."
  exit 1
fi

echo "Loading profile: $PROFILE_NAME (from $PROFILE_DIR)"
echo ""

# Ensure base dependencies are installed
source "$GNOMAD_LIB_DIR/utils/utils.sh"
echo "Verifying base dependencies..."
install_packages "$PKG_DCONF" "$PKG_PIPX" "$PKG_GNOME_EXTENSIONS"
echo ""

bash "$GNOMAD_LIB_DIR/utils/import/import-extensions.sh" "$PROFILE_DIR"
bash "$GNOMAD_LIB_DIR/utils/import/import-workspace.sh"  "$PROFILE_DIR"
bash "$GNOMAD_LIB_DIR/utils/import/import-wallpapers.sh" "$PROFILE_DIR" "$PROFILE_NAME"
bash "$GNOMAD_LIB_DIR/utils/import/import-configs.sh"    "$PROFILE_DIR"

echo ""
echo "✓ Profile '$PROFILE_NAME' loaded successfully."
