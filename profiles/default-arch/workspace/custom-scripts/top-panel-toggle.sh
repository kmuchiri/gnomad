#!/usr/bin/env bash
KEY="/org/gnome/shell/extensions/just-perfection/panel"

cur=$(dconf read "$KEY")
if [ "$cur" = "true" ]; then
  dconf write "$KEY" false
else
  dconf write "$KEY" true
fi