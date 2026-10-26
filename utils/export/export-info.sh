#!/bin/bash

PROFILE_DIR="$1"

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

source "$SCRIPT_DIR/../utils.sh"


#make  info/conf file
shellVersion=$(gnome-shell --version | cut -d' ' -f3)
extValidationCheck=$(gsettings get org.gnome.shell disable-extension-version-validation)


touch "$PROFILE_DIR/config.conf"


echo "shell_version=$shellVersion" > "$PROFILE_DIR/config.conf"
echo "ext_val_check=$extValidationCheck" >> "$PROFILE_DIR/config.conf"
echo "linux_distro=$DISTRO_STR" >> "$PROFILE_DIR/config.conf"

echo "[info] config info placed in $PROFILE_DIR/config.conf"