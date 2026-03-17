#!/bin/bash

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PROFILES_DIR="$ROOT_DIR/profiles"

if [ ! -d "$PROFILES_DIR" ] || [ -z "$(ls -A "$PROFILES_DIR" 2>/dev/null)" ]; then
  echo "No profiles found."
  echo "Create one with: ./gnomad create <name>"
  exit 0
fi

echo "Available profiles:"
echo ""
for profile_path in "$PROFILES_DIR"/*/; do
  [ -d "$profile_path" ] || continue
  name=$(basename "$profile_path")
  echo "  • $name"
done
echo ""
echo "Load a profile with: ./gnomad load <name>"
