#!/bin/bash

CURRENT_HOUR=$(date +%H)

# Dark window: 6 PM (18:00) to 6 AM (07:00)
if [ "$CURRENT_HOUR" -ge 18 ] || [ "$CURRENT_HOUR" -lt 7 ]; then
    TARGET_THEME="'Adwaita-dark'"
else
    TARGET_THEME="'Adwaita'"
fi

# Apply the theme preference
gsettings set org.gnome.desktop.interface color-scheme "$TARGET_THEME"

~/.config/hypr/apply-theme.sh

notify-send "Theme" "Switched theme"
