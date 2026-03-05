# GNOMad

A setup migration utility script for GNOME DE.

Captures your current GNOME environment into a profile, enabling a quick duplicate setup on a different machine.

Note: This script focuses on extensions, keybindings, wallpaper and workspace configurations, as well as optional bash configuraitons. For addtional setup e.g. applications, add functionality or use another utility. 

# Usage

```bash
./gnomad.sh create <profile-name> # Snapshot current system into a profile
./gnomad.sh load <profile-name> #Apply a saved profile to the system
./gnomad.sh list # List all saved profiles


```
