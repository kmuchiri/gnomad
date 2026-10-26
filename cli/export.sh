#!/bin/bash

PROFILE_NAME="$1"
DEST_DIR="$2"

if [ -z "$PROFILE_NAME" ]; then
  echo "Usage: gnomad export <profile-name> [destination-dir]"
  echo ""
  echo "Extracts a saved profile to the specified directory."
  echo "If destination-dir is omitted, defaults to './<profile-name>'."
  exit 1
fi

GNOMAD_LIB_DIR="${GNOMAD_LIB_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
GNOMAD_DATA_DIR="${GNOMAD_DATA_DIR:-$GNOMAD_LIB_DIR}"
GNOMAD_USER_PROFILES_DIR="${GNOMAD_USER_PROFILES_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/gnomad/profiles}"

# Locate source profile
if [ -d "$GNOMAD_USER_PROFILES_DIR/$PROFILE_NAME" ]; then
  SOURCE_DIR="$GNOMAD_USER_PROFILES_DIR/$PROFILE_NAME"
  SOURCE_TYPE="user"
elif [ -d "$GNOMAD_DATA_DIR/builtin-profiles/$PROFILE_NAME" ]; then
  SOURCE_DIR="$GNOMAD_DATA_DIR/builtin-profiles/$PROFILE_NAME"
  SOURCE_TYPE="built-in"
elif [ -d "$GNOMAD_DATA_DIR/profiles/$PROFILE_NAME" ]; then
  SOURCE_DIR="$GNOMAD_DATA_DIR/profiles/$PROFILE_NAME"
  SOURCE_TYPE="built-in"
else
  echo "Error: Profile '$PROFILE_NAME' not found."
  echo "Run 'gnomad list' to see available profiles."
  exit 1
fi

# Default destination
if [ -z "$DEST_DIR" ]; then
  DEST_DIR="./$PROFILE_NAME"
fi

if [ -d "$DEST_DIR" ] && [ -n "$(ls -A "$DEST_DIR" 2>/dev/null)" ]; then
  echo "Destination directory '$DEST_DIR' already exists and is not empty. Overwrite? [y/N] "
  read -r answer
  if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
    echo "Export aborted."
    exit 0
  fi
fi

mkdir -p "$DEST_DIR"
cp -r "$SOURCE_DIR/." "$DEST_DIR/"

echo "✓ Profile '$PROFILE_NAME' ($SOURCE_TYPE) successfully exported to:"
echo "  $DEST_DIR"
