# gnomad

A setup migration utility for GNOME Desktop Environments.

Captures your current GNOME environment into a profile, and duplicates it on another machine.

> [!NOTE]
> This script focuses on extensions, keybindings, wallpaper and workspace configurations, as well as optional configs. For additional setup (e.g. general applications), add custom scripts or use another utility.

---

## Requirements

- **System**: Arch, Fedora, or Debian/Ubuntu-based distributions with GNOME 45+ (tested on Arch with GNOME 48, 49).
- **Dependencies**: Recommended to install before loading a profile (the `load` command will also attempt to auto-install them):

### Arch
```bash
sudo pacman -S python-pipx gnome-shell-extensions
```

### Fedora
```bash
sudo dnf install -y python-pipx gnome-shell-extensions
```

### Debian / Ubuntu
```bash
sudo apt-get install -y python3-pipx gnome-shell-extensions
```

---

## Installation

You can install `gnomad` as a system or user executable, run it in-tree, or compile it into a single standalone binary.

### Option 1: Rootless User Install (Recommended)
Installs binary to `~/.local/bin/gnomad` and libraries to `~/.local/share/gnomad/`:
```bash
./install.sh --user
```
*(Ensure `~/.local/bin` is in your `$PATH`)*

### Option 2: System-Wide Install
Installs to `/usr/local/bin` and `/usr/local/share/gnomad`:
```bash
sudo make install
# Or:
sudo ./install.sh --system
```

### Option 3: Standalone Single-File Binary
Build a portable, self-extracting single executable with zero external dependencies:
```bash
make bundle
# Output is located at dist/gnomad:
./dist/gnomad --help
```
You can move `dist/gnomad` anywhere in your `$PATH` (e.g. `/usr/local/bin/gnomad`).

### Option 4: Arch Linux Package
Build and install using `pacman`:
```bash
cd packaging/arch
makepkg -si
```

### Uninstallation
```bash
./install.sh --uninstall
# Or:
sudo make uninstall
```

---

## Usage

Once installed, you can invoke `gnomad` from any terminal directory:

```bash
gnomad create <profile-name>        # Snapshot current system into a user profile
gnomad load   <profile-name>        # Apply a profile to the system
gnomad list                         # List available profiles (user and built-in)
gnomad export <profile-name> [dir]  # Extract a profile to an external directory
gnomad import <dir> [profile-name]  # Import a profile directory into user profiles
```

> [!IMPORTANT]
> - Extension installation prompts the GNOME GUI for approval on each extension.
> - A known GNOME Shell quirk may briefly restart the shell during extension installation, which can log the user out. Re-running the command resumes setup.
> - `sudo` may be required to copy wallpapers into system directories.

---

## Profile Management & Locations

- **User Profiles**: Stored in `~/.local/share/gnomad/profiles/<name>/` (`$XDG_DATA_HOME/gnomad/profiles/`).
- **Built-in Profiles**: Shipped in `/usr/local/share/gnomad/profiles/` (or `~/.local/share/gnomad/profiles/` for user installs).
- **Exporting a Profile**:
  ```bash
  gnomad export default-arch ~/my-backups/default-arch
  ```
- **Importing a Profile**:
  ```bash
  gnomad import ~/my-backups/default-arch custom-arch
  ```

### What does a Profile Capture?

| Folder | What's Saved |
| :--- | :--- |
| **Extensions** | Enabled extension UUIDs + all extension dconf settings |
| **Workspace** | WM keybindings, custom shortcuts, mutter settings, shell keybindings |
| **Wallpapers** | Light and dark wallpapers + picture options |
| **Configs** | App configs (e.g., Kitty terminal configs) |
| **Custom Scripts** | Any scripts located in `~/.custom-scripts/` |

---

## Repo Structure

```text
.
├── cli/           # CLI command scripts (create, load, list, export, import)
├── dist/          # Output directory for standalone bundle binary (make bundle)
├── packaging/     # Package recipes (Arch PKGBUILD)
├── profiles/      # Built-in reference profiles (default, default-arch)
├── scripts/       # Bundling and build scripts
├── utils/         # OS detection, import, and export utilities
├── gnomad         # Entrypoint executable
├── install.sh     # Interactive / automated installer
└── Makefile       # Standard Unix build & installation Makefile
```

---

## Custom Scripts & Extensions

To add custom import/export scripts:
1. Place custom scripts in `utils/custom/`.
2. Add the export routine to `cli/create.sh` and the import routine to `cli/load.sh`.
