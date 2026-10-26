# gnomad

A setup migration utility for GNOME Desktop Environments.

Captures your current GNOME environment into a profile, and duplicates it on another machine.

> [!NOTE]
> This script focuses on extensions, keybindings, wallpaper and workspace configurations, as well as optional configs. For additional setup (e.g. general applications), add custom scripts or use another utility.

---

## Installation

Install `gnomad` on any Linux distribution running GNOME with a single command (no root/sudo required):

```bash
curl -fsSL https://raw.githubusercontent.com/kmuchiri/gnomad/main/install.sh | bash
```

*(Ensure `~/.local/bin` is in your `$PATH`)*

### Other Installation Options

- **System-Wide Install** (requires sudo):
  ```bash
  curl -fsSL https://raw.githubusercontent.com/kmuchiri/gnomad/main/install.sh | sudo bash -s -- --system
  ```

- **Local Git Clone Install**:
  ```bash
  ./install.sh
  ```

- **Standalone Single-File Binary**:
  Build a portable, self-extracting single executable with zero external dependencies:
  ```bash
  make bundle
  # Generated binary located at dist/gnomad
  ./dist/gnomad --help
  ```

### Uninstallation

```bash
curl -fsSL https://raw.githubusercontent.com/kmuchiri/gnomad/main/install.sh | bash -s -- --uninstall
```
*(Your custom user profiles in `~/.local/share/gnomad/profiles/` are always preserved.)*

---

## Requirements & Dependencies

- **System**: Any Linux distribution with GNOME 45+ (e.g. Arch, Fedora, Ubuntu/Debian, openSUSE).
- **Core Dependencies**: `bash`, `dconf`, `python-pipx`, `gnome-shell-extensions`.
  *(When running `gnomad load`, it will automatically detect your package manager and attempt to install any missing dependencies).*

---

## Usage

Once installed, you can invoke `gnomad` directly from any directory:

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
- **Built-in Profiles**: Shipped in `~/.local/share/gnomad/builtin-profiles/` (or `/usr/local/share/gnomad/builtin-profiles/`).
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
├── profiles/      # Built-in reference profiles (default, default-arch)
├── scripts/       # Bundling and build scripts
├── utils/         # OS detection, import, and export utilities
├── gnomad         # Entrypoint executable
├── install.sh     # Distro-agnostic curl and local installer
└── Makefile       # Standard Unix build & installation Makefile
```

---

## Custom Scripts & Extensions

To add custom import/export scripts:
1. Place custom scripts in `utils/custom/`.
2. Add the export routine to `cli/create.sh` and the import routine to `cli/load.sh`.
