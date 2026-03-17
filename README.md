# GNOMad

A setup migration utility script for GNOME DE.

Captures your current GNOME environment into a profile, and duplicates it on another machine.

Note: This script focuses on extensions, keybindings, wallpaper and workspace configurations, as well as optional bash configuraitons. For addtional setup e.g. applications, add functionality or use another utility.

## Requirements

*system*: Arch, Fedora or Debian based distributions with GNOME 45+ (tested on Arch Based Distro with GNOME 48,49)

*Dependencies* - Recommended to install before loading any profile, however load option will attempt to install them if missing.

### Arch

```bash
sudo pacman -S python-pipx gnome-shell-extensions
```

### Fedora

```bash
sudo dnf install -y python-pipx gnome-shell-extensions
```

### Debian

```bash
sudo apt-get install -y python3-pipx gnome-shell-extensions
```

## Usage

```bash
./gnomad create <profile-name> # Snapshot current system into a profile
./gnomad load <profile-name> #Apply a saved profile to the system
./gnomad list # List all saved profiles

```

Note: This is not an unsupervised install script.

- The GUI is invoked when installing extentions. This means that for each extension you have to select install when prompted.
- There is a bug that restarts the shell during extension installation, logging the user out. Running the script again will resume the setup process.
- To copy wallpapers and other files, sudo is required.

## Profile

### What does a Profile Capture

| Folder | what's Saved |
| --- | --- |
| Extensions | Enable extension UUIDs + all extension dconf settings |
| Workspace | WM keybindings, custom shortcuts, mutter settings |
| Wallpapers | Light and dark wallpapers (optional) + picture options + Wallpaper Collection |
| Configs | App configs, terminal configs + bash configs (tbd) |
| Custom Scripts (Optional) | any scripts in ~/custom-scripts/ |

### Creating a New Profile

Run `create` on a machine you've already customised and configured to your liking. All settiings are captured from the live GNOME session via `dconf dump` and `gsettings get`.

No manual editing required

```bash
./gnomad create my-setup
```

### Loading a Profile

Run the following on the machine you'd like to configure.

```bash
./gnomad load my-setup
```

## Utils

Contains the OS detection and utility functions for each distro. Also contains the export and import scripts.

### Creating a custom scripts

To create custom import/export scripts, create a new file in the utils/custom directory. Add the import to create and the export to the load cli.
