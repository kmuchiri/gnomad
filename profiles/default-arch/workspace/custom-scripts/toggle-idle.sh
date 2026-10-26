#!/bin/bash

# Toggle Hypridle

pkill hypridle || hypridle &

sleep 0.2

if pgrep -x "hypridle" > /dev/null; then 
	notify-send "Hypridle" "Hypridle enabled"
else
	notify-send "Hypridle" "Hypridle disabled"
fi
