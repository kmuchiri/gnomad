#!/bin/bash

SOURCE_DIR="$1"
PROFILE_NAME="$2"

if [ -z "$SOURCE_DIR" ]; then
  echo "Usage: gnomad import <source-dir> [profile-name]"
  echo ""
  echo "Imports a profile directory into your user profiles store."
  echo "If profile-name is omitted, the name of source directory is used."
  exit 1
fi

if [ ! -d "$SOURCE_DIR" ]; then
  echo "Error: Source directory '$SOURCE_DIR' does not exist."
  exit 1
fi

# Determine profile name
if [ -z "$PROFILE_NAME" ]; then
  # Strip trailing slash if present
  CLEAN_SRC="${SOURCE_DIR%/}"
  PROFILE_NAME="$(basename "$CLEAN_SRC")"
fi

# Basic validation
if [ ! -f "$SOURCE_DIR/config.conf" ] && \
   [ ! -d "$SOURCE_DIR/extensions" ] && \
   [ ! -d "$SOURCE_DIR/workspace" ] && \
   [ ! -d "$SOURCE_DIR/wallpapers" ] && \
   [ ! -d "$SOURCE_DIR/configs" ]; then
  echo "Warning: '$SOURCE_DIR' does not contain standard gnomad profile folders (extensions, workspace, wallpapers, configs, config.conf)."
  echo "Proceed with import anyway? [y/N] "
  read -r answer
  if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
    echo "Import aborted."
    exit 0
  fi
fi

GNOMAD_USER_PROFILES_DIR="${GNOMAD_USER_PROFILES_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/gnomad/profiles}"
DEST_DIR="$GNOMAD_USER_PROFILES_DIR/$PROFILE_NAME"

if [ -d "$DEST_DIR" ]; then
  echo "A profile named '$PROFILE_NAME' already exists in $GNOMAD_USER_PROFILES_DIR. Overwrite? [y/N] "
  read -r answer
  if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
    echo "Import aborted."
    exit 0
  fi
fi

mkdir -p "$DEST_DIR"
cp -r "$SOURCE_DIR/." "$DEST_DIR/"

echo "✓ Profile '$PROFILE_NAME' successfully imported into user profiles:"
echo "  $DEST_DIR"
echo ""
echo "You can now load it anytime with: gnomad load $PROFILE_NAME"
