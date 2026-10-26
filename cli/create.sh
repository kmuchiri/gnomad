#!/bin/bash

PROFILE_NAME="$1"

if [ -z "$PROFILE_NAME" ]; then
  echo "Usage: gnomad create <profile-name>"
  exit 1
fi

GNOMAD_LIB_DIR="${GNOMAD_LIB_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
GNOMAD_USER_PROFILES_DIR="${GNOMAD_USER_PROFILES_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/gnomad/profiles}"

PROFILE_DIR="$GNOMAD_USER_PROFILES_DIR/$PROFILE_NAME"

if [ -d "$PROFILE_DIR" ]; then
  echo "Profile '$PROFILE_NAME' already exists in $GNOMAD_USER_PROFILES_DIR. Overwrite? [y/N] "
  read -r answer
  if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
    echo "Overwrite Aborted."
    exit 0
  fi
fi

echo "Creating profile: $PROFILE_NAME"
echo ""

mkdir -p "$PROFILE_DIR/extensions"
mkdir -p "$PROFILE_DIR/workspace"
mkdir -p "$PROFILE_DIR/wallpapers"
mkdir -p "$PROFILE_DIR/configs"

bash "$GNOMAD_LIB_DIR/utils/export/export-extensions.sh"  "$PROFILE_DIR"
bash "$GNOMAD_LIB_DIR/utils/export/export-workspace.sh"   "$PROFILE_DIR"
bash "$GNOMAD_LIB_DIR/utils/export/export-wallpapers.sh"  "$PROFILE_DIR"
bash "$GNOMAD_LIB_DIR/utils/export/export-configs.sh"     "$PROFILE_DIR"
bash "$GNOMAD_LIB_DIR/utils/export/export-info.sh"        "$PROFILE_DIR"

echo ""
echo "✓ Profile '$PROFILE_NAME' saved to $PROFILE_DIR"
