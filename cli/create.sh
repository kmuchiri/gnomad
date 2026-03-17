#!/bin/bash

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROFILE_NAME="$1"

if [ -z "$PROFILE_NAME" ]; then
  echo "Usage: gnomad-arch.sh create <profile-name>"
  exit 1
fi

PROFILE_DIR="$ROOT_DIR/profiles/$PROFILE_NAME"

if [ -d "$PROFILE_DIR" ]; then
  echo "Profile '$PROFILE_NAME' already exists. Overwrite? [y/N] "
  read -r answer
  if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
    echo "Aborted."
    exit 0
  fi
fi

echo "Creating profile: $PROFILE_NAME"
echo ""

mkdir -p "$PROFILE_DIR/extensions"
mkdir -p "$PROFILE_DIR/workspace"
mkdir -p "$PROFILE_DIR/wallpapers"
mkdir -p "$PROFILE_DIR/configs"

bash "$ROOT_DIR/utils/export/export-extensions.sh"  "$PROFILE_DIR"
bash "$ROOT_DIR/utils/export/export-workspace.sh"   "$PROFILE_DIR"
bash "$ROOT_DIR/utils/export/export-wallpapers.sh"  "$PROFILE_DIR"
bash "$ROOT_DIR/utils/export/export-configs.sh"     "$PROFILE_DIR"

echo ""
echo "✓ Profile '$PROFILE_NAME' saved to profiles/$PROFILE_NAME/"
