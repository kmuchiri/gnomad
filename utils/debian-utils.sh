#!/bin/bash

# Debian/Ubuntu Utilities
export PKG_PIPX="pipx"
export PKG_GNOME_EXTENSIONS="gnome-shell-extensions"
export PKG_DCONF="dconf-cli"

# Function to check if a package is installed
is_installed() {
  dpkg -l "$1" &> /dev/null
}

# Function to check if a package group is installed
is_group_installed() {
  # Debian doesn't have package groups exactly like Arch, fallback to normal check
  is_installed "$1"
}

# Function to install packages if not already installed
install_packages() {
  local packages=("$@")
  local to_install=()

  for pkg in "${packages[@]}"; do
    if ! is_installed "$pkg"; then
      to_install+=("$pkg")
    fi
  done

  if [ ${#to_install[@]} -ne 0 ]; then
    echo "Installing: ${to_install[*]}"
    sudo apt-get update
    sudo apt-get install -y "${to_install[@]}"
  fi
}
