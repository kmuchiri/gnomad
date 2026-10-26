#!/bin/bash
set -e

GNOMAD_REPO="${GNOMAD_REPO:-kmuchiri/gnomad}"
GNOMAD_BRANCH="${GNOMAD_BRANCH:-main}"

print_usage() {
  echo "gnomad installer"
  echo ""
  echo "Usage: install.sh [OPTIONS]"
  echo ""
  echo "Options:"
  echo "  --user         Install to ~/.local (default, no root/sudo required)"
  echo "  --system       Install to /usr/local (requires sudo/root)"
  echo "  --uninstall    Uninstall gnomad"
  echo "  -h, --help     Show this help message"
  echo ""
  echo "Quick Install via curl:"
  echo "  curl -fsSL https://raw.githubusercontent.com/${GNOMAD_REPO}/${GNOMAD_BRANCH}/install.sh | bash"
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

# Handle uninstallation
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

# Detect whether running locally in a cloned repository or piped via curl
LOCAL_DIR=""
if [ -n "${BASH_SOURCE[0]}" ] && [ "${BASH_SOURCE[0]}" != "bash" ] && [ "${BASH_SOURCE[0]}" != "/dev/stdin" ]; then
  LOCAL_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" 2>/dev/null && pwd || true)"
fi

CLEANUP_TMP=false
if [ -n "$LOCAL_DIR" ] && [ -f "$LOCAL_DIR/gnomad" ] && [ -d "$LOCAL_DIR/cli" ] && [ -d "$LOCAL_DIR/utils" ]; then
  SRC_DIR="$LOCAL_DIR"
else
  # Running via curl / remote pipe: fetch archive from GitHub
  echo "Fetching gnomad (${GNOMAD_BRANCH}) from GitHub (${GNOMAD_REPO})..."
  TMP_DIR="$(mktemp -d /tmp/gnomad-install.XXXXXX)"
  CLEANUP_TMP=true
  trap '[ "$CLEANUP_TMP" = true ] && rm -rf "$TMP_DIR"' EXIT

  ARCHIVE_URL="https://github.com/${GNOMAD_REPO}/archive/refs/heads/${GNOMAD_BRANCH}.tar.gz"

  if command -v curl >/dev/null 2>&1; then
    curl -fsSL "$ARCHIVE_URL" -o "$TMP_DIR/archive.tar.gz"
  elif command -v wget >/dev/null 2>&1; then
    wget -qO "$TMP_DIR/archive.tar.gz" "$ARCHIVE_URL"
  else
    echo "Error: Neither curl nor wget was found. Please install curl or wget." >&2
    exit 1
  fi

  tar -xzf "$TMP_DIR/archive.tar.gz" -C "$TMP_DIR"
  EXTRACTED_DIR="$(find "$TMP_DIR" -mindepth 1 -maxdepth 1 -type d | head -n 1)"
  if [ -z "$EXTRACTED_DIR" ] || [ ! -f "$EXTRACTED_DIR/gnomad" ]; then
    echo "Error: Failed to unpack gnomad archive." >&2
    exit 1
  fi
  SRC_DIR="$EXTRACTED_DIR"
fi

echo "Installing gnomad ($MODE mode)..."
echo "  Target binary:    $BIN_DIR/gnomad"
echo "  Target libraries: $SHARE_DIR"
echo ""

# Ensure target directories exist
mkdir -p "$BIN_DIR"
mkdir -p "$SHARE_DIR"

# Install main executable
install -m 755 "$SRC_DIR/gnomad" "$BIN_DIR/gnomad"

# Install libraries and bundled reference profiles
cp -r "$SRC_DIR/cli" "$SHARE_DIR/"
cp -r "$SRC_DIR/utils" "$SHARE_DIR/"
rm -rf "$SHARE_DIR/builtin-profiles"
cp -r "$SRC_DIR/profiles" "$SHARE_DIR/builtin-profiles"

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
