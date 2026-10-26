#!/bin/bash

GNOMAD_LIB_DIR="${GNOMAD_LIB_DIR:-$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)}"
GNOMAD_DATA_DIR="${GNOMAD_DATA_DIR:-$GNOMAD_LIB_DIR}"
GNOMAD_USER_PROFILES_DIR="${GNOMAD_USER_PROFILES_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/gnomad/profiles}"

# Locate built-in profiles directory
BUILTIN_DIR=""
if [ -d "$GNOMAD_DATA_DIR/builtin-profiles" ]; then
  BUILTIN_DIR="$GNOMAD_DATA_DIR/builtin-profiles"
elif [ -d "$GNOMAD_DATA_DIR/profiles" ] && [ "$GNOMAD_DATA_DIR/profiles" != "$GNOMAD_USER_PROFILES_DIR" ]; then
  BUILTIN_DIR="$GNOMAD_DATA_DIR/profiles"
fi

found_any=false
echo "Available profiles:"
echo ""

# Track listed names to avoid duplicates
declare -A listed_profiles

# 1. User profiles
if [ -d "$GNOMAD_USER_PROFILES_DIR" ]; then
  for profile_path in "$GNOMAD_USER_PROFILES_DIR"/*/; do
    [ -d "$profile_path" ] || continue
    name=$(basename "$profile_path")
    echo "  • $name [user]"
    listed_profiles["$name"]=1
    found_any=true
  done
fi

# 2. Built-in profiles
if [ -n "$BUILTIN_DIR" ] && [ -d "$BUILTIN_DIR" ]; then
  for profile_path in "$BUILTIN_DIR"/*/; do
    [ -d "$profile_path" ] || continue
    name=$(basename "$profile_path")
    if [ -n "${listed_profiles[$name]}" ]; then
      continue
    fi
    echo "  • $name [built-in]"
    listed_profiles["$name"]=1
    found_any=true
  done
fi

if [ "$found_any" = false ]; then
  echo "  (No profiles found)"
  echo ""
  echo "Create one with: gnomad create <name>"
  exit 0
fi

echo ""
echo "Load a profile with: gnomad load <name>"
