#!/bin/bash

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROFILE_NAME="$1"

if [ -z "$PROFILE_NAME" ]; then
  echo "Usage: gnomad-arch.sh load <profile-name>"
  exit 1
fi

PROFILE_DIR="$ROOT_DIR/profiles/$PROFILE_NAME"

if [ ! -d "$PROFILE_DIR" ]; then
  echo "Error: Profile '$PROFILE_NAME' not found."
  echo "Run './gnomad-arch.sh list' to see available profiles."
  exit 1
fi

echo "Loading profile: $PROFILE_NAME"
echo ""

bash "$ROOT_DIR/utils/import/import-extensions.sh" "$PROFILE_DIR"
bash "$ROOT_DIR/utils/import/import-workspace.sh"  "$PROFILE_DIR"
bash "$ROOT_DIR/utils/import/import-wallpapers.sh" "$PROFILE_DIR" "$PROFILE_NAME"
bash "$ROOT_DIR/utils/import/import-configs.sh"    "$PROFILE_DIR"

echo ""
echo "✓ Profile '$PROFILE_NAME' loaded successfully."
