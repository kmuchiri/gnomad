#!/bin/bash
set -e

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

print_usage() {
  echo "Usage: ./install.sh [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  --user         Install to ~/.local (no root/sudo required)"
  echo "  --system       Install to /usr/local (requires sudo/root)"
  echo "  --uninstall    Uninstall gnomad"
  echo "  -h, --help     Show this help message"
  echo ""
}

MODE="auto"
ACTION="install"

while [[ $# -gt 0 ]]; do
  case "$1" in
    --user)
      MODE="user"
      shift
      ;;
    --system)
      MODE="system"
      shift
      ;;
    --uninstall)
      ACTION="uninstall"
      shift
      ;;
    -h|--help)
      print_usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1"
      print_usage
      exit 1
      ;;
  esac
done

# Auto-detect mode if not explicitly specified
if [ "$MODE" = "auto" ]; then
  if [ "$EUID" -eq 0 ]; then
    MODE="system"
  else
    MODE="user"
  fi
fi

if [ "$MODE" = "system" ]; then
  PREFIX="/usr/local"
  BIN_DIR="$PREFIX/bin"
  SHARE_DIR="$PREFIX/share/gnomad"
else
  PREFIX="$HOME/.local"
  BIN_DIR="$PREFIX/bin"
  SHARE_DIR="$PREFIX/share/gnomad"
fi

if [ "$ACTION" = "uninstall" ]; then
  echo "Uninstalling gnomad from $PREFIX..."
  if [ -f "$BIN_DIR/gnomad" ]; then
    rm -f "$BIN_DIR/gnomad"
    echo "  Removed $BIN_DIR/gnomad"
  fi
  if [ -d "$SHARE_DIR" ]; then
    rm -rf "$SHARE_DIR/cli" "$SHARE_DIR/utils" "$SHARE_DIR/builtin-profiles"
    echo "  Removed gnomad libraries and built-in profiles from $SHARE_DIR"
    rmdir "$SHARE_DIR" 2>/dev/null || true
  fi
  echo "✓ gnomad has been uninstalled."
  echo "Note: Your user profiles in ${XDG_DATA_HOME:-$HOME/.local/share}/gnomad/profiles were preserved."
  exit 0
fi

echo "Installing gnomad ($MODE mode)..."
echo "  Target binary:    $BIN_DIR/gnomad"
echo "  Target libraries: $SHARE_DIR"
echo ""

# Ensure target directories exist
mkdir -p "$BIN_DIR"
mkdir -p "$SHARE_DIR"

# Install main executable
install -m 755 "$REPO_ROOT/gnomad" "$BIN_DIR/gnomad"

# Install libraries and bundled reference profiles
cp -r "$REPO_ROOT/cli" "$SHARE_DIR/"
cp -r "$REPO_ROOT/utils" "$SHARE_DIR/"
rm -rf "$SHARE_DIR/builtin-profiles"
cp -r "$REPO_ROOT/profiles" "$SHARE_DIR/builtin-profiles"

chmod -R 755 "$SHARE_DIR/cli"
chmod -R 755 "$SHARE_DIR/utils"

echo "✓ Successfully installed gnomad to $BIN_DIR/gnomad"

# Check if BIN_DIR is in PATH
if [[ ":$PATH:" != *":$BIN_DIR:"* ]]; then
  echo ""
  echo "⚠️  Warning: $BIN_DIR is not currently in your PATH."
  echo "Add the following line to your ~/.bashrc or ~/.zshrc:"
  echo "  export PATH=\"\$PATH:$BIN_DIR\""
fi

echo ""
echo "Try running: gnomad list"
