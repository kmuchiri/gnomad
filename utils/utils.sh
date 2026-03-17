#!/bin/bash

# Detect OS
if [ -f "/etc/os-release" ]; then
  . /etc/os-release
  OS=$ID
  OS_ID_LIKE=$ID_LIKE
else
  echo "Unsupported OS: Unknown"
  exit 1
fi

UTILS_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Route to proper utils and export DISTRO_STR
if [[ "$OS" == "arch" || "$OS_ID_LIKE" == *"arch"* ]]; then
  export DISTRO_STR="ARCH"
  source "$UTILS_DIR/arch-utils.sh"
elif [[ "$OS" == "debian" || "$OS" == "ubuntu" || "$OS_ID_LIKE" == *"debian"* || "$OS_ID_LIKE" == *"ubuntu"* ]]; then
  export DISTRO_STR="DEBIAN"
  source "$UTILS_DIR/debian-utils.sh"
elif [[ "$OS" == "fedora" || "$OS_ID_LIKE" == *"fedora"* ]]; then
  export DISTRO_STR="FEDORA"
  source "$UTILS_DIR/fedora-utils.sh"
else
  echo "OS unsupported or not identified: $OS"
  echo "Currently supported: Arch, Debian/Ubuntu, Fedora"
  exit 1
fi