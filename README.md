<div align="center">

# ✨ Aesthetic Hyprland Dotfiles

[![OS - Arch Linux](https://img.shields.io/badge/OS-Arch%20%7C%20Fedora%20%7C%20Ubuntu-blue?style=for-the-badge&logo=linux)](https://archlinux.org)
[![WM - Hyprland](https://img.shields.io/badge/WM-Hyprland-58E189?style=for-the-badge&logo=hyprland)](https://hyprland.org)
[![Config - Lua](https://img.shields.io/badge/Config-Lua-000080?style=for-the-badge&logo=lua)](https://lua.org)
[![Deployment - GNU Stow](https://img.shields.io/badge/Deployment-GNU%20Stow-informational?style=for-the-badge&logo=gnu)](https://www.gnu.org/software/stow/)
[![Shell - Zsh](https://img.shields.io/badge/Shell-Zsh%20%2B%20Oh--My--Posh-purple?style=for-the-badge&logo=zsh)](https://ohmyposh.dev)

A complete, modern, and beautifully crafted Hyprland ecosystem configuration featuring Lua-based window management, dynamic theme generation, shell state persistence with **Noctalia**, wallpaper switching via **Waypaper**, and multiple tuned terminal environments.

</div>

---

## 🌟 Key Features

- **🚀 Hyprland Lua Configuration (`hyprland.lua`)**: Modular, clean, and declarative window management configuration written in Lua.
- **🎨 Dynamic Theming & Color Schemes**: Integrated with **Wallust** and **Noctalia** state manager for fluid wallpaper-based palette generation.
- **🖼️ Waypaper Wallpaper Engine**: Integrated wallpaper selector supporting animated and static wallpapers.
- **💻 Multi-Terminal Suite**: Preconfigured settings for **Kitty**, **Ghostty**, and **Wezterm**.
- **📊 System Monitoring & Information**: Modern **Fastfetch** configs alongside custom styled **Btop** and **Htop**.
- **🐚 Prompt & Shell Setup**: Custom **Zsh** environment powered by **Oh-My-Posh** for fast, aesthetic prompt rendering.
- **🖥️ Multi-Monitor & Display Management**: Easily configure output resolution and scaling using **nwg-displays** and `monitors.lua`.

---

## 📂 Repository Structure

```text
.
├── hypr/               # Hyprland WM configs (hyprland.lua, hyprlock, hypridle, wallpapers)
├── noctalia/           # Noctalia shell state, plugins, settings, and themes
├── waypaper/           # Waypaper GUI configuration & wallpaper engine settings
├── kitty/              # Kitty terminal emulator configuration & color palettes
├── ghostty/            # Ghostty terminal emulator configuration
├── wezterm/            # Wezterm Lua configuration & keybindings
├── fastfetch/          # Fastfetch system info layout & logo presets
├── btop/               # Btop resource monitor theme & layouts
├── htop/               # Htop configuration
├── gtk/                # GTK3 / GTK4 theme & icon settings
├── qt/                 # Qt5ct / Qt6ct styling configuration
├── nwg/                # nwg-displays output management configuration
├── scripts/            # Custom helper binaries & utilities (~/.local/bin)
├── zsh/                # Custom .zshrc with Oh-My-Posh prompt integration
└── install.sh          # One-click automated setup & deployment script
```

---

## 🚀 Quick Start Installation

Run the automated restoration script directly from your terminal:

```bash
git clone https://github.com/your-username/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

### What `install.sh` handles automatically:
1. **Package Detection & Installation**: Identifies package manager (`pacman`, `dnf`, or `apt`) and installs missing core dependencies, AUR tools (`yay`/`paru`), or Ubuntu PPA/Pip/Cargo packages.
2. **Automated Ubuntu Support**: On Ubuntu/Debian, `install.sh` automatically attempts adding the Hyprland PPA (`ppa:cppwm/hyprland`), installs `waypaper` via `pip`, and installs `wallust` via `cargo`.
3. **Permissions Setup**: Ensures all scripts in `scripts/.local/bin/` are executable.
4. **Environment Integration**: Ensures `~/.local/bin` is exported in your `$PATH`.
5. **GNU Stow Symlinking**: Deploys configuration modules into `~/.config`, `~/.local`, and `~/` with safe fallback logic.
6. **Shell Configuration**: Offers to set `zsh` as your default shell and reloads Hyprland if active.

---

## 📦 Package Dependency Matrix

| Component | Arch Linux (`pacman`/`AUR`) | Fedora (`dnf`) | Debian / Ubuntu (`apt` / `pip` / `cargo`) |
| :--- | :--- | :--- | :--- |
| **Window Manager** | `hyprland` | `hyprland` | `hyprland` *(PPA: cppwm/hyprland or GitHub binaries)* |
| **Dotfile Deployment** | `stow` | `stow` | `stow` |
| **Terminals** | `kitty`, `ghostty` *(AUR)*, `wezterm` *(AUR)* | `kitty` | `kitty`, `ghostty` / `wezterm` *(GitHub .deb)* |
| **Screen Lock & Idle**| `hyprlock`, `hypridle` | `hyprlock`, `hypridle` | `hyprlock` / `swaylock` |
| **Wallpaper & Colors** | `waypaper`, `wallust` | `waypaper` | `waypaper` *(pip)*, `wallust` *(cargo)* |
| **Screen Capture** | `grim`, `slurp`, `wl-clipboard` | `grim`, `slurp`, `wl-clipboard` | `grim`, `slurp`, `wl-clipboard` |
| **System Info & Monitors**| `fastfetch`, `btop`, `htop` | `fastfetch`, `btop`, `htop` | `fastfetch`, `btop`, `htop` |
| **Fonts** | `ttf-jetbrains-mono-nerd`, `ttf-font-awesome` | `jetbrains-mono-fonts`, `fontawesome-fonts` | `fonts-jetbrains-mono`, `fonts-font-awesome` |

---

## ⌨️ Keybindings Cheat Sheet

| Key Combination | Action | Description |
| :--- | :--- | :--- |
| `SUPER + RETURN` | Launch Terminal | Opens default terminal (`kitty`) |
| `SUPER + E` | File Manager | Opens file manager |
| `SUPER + R` / `SUPER + SPACE` | App Launcher | Opens application menu / Noctalia launcher |
| `SUPER + Q` | Kill Window | Closes focused window |
| `SUPER + V` | Toggle Floating | Toggles window float mode |
| `SUPER + F` | Fullscreen | Toggles window fullscreen |
| `SUPER + H / J / K / L` | Focus Direction | Move focus across tiled windows |
| `SUPER + 1 - 9` | Switch Workspace | Switch active workspace |
| `SUPER + SHIFT + 1 - 9` | Move Window | Move focused window to workspace |
| `SUPER + SHIFT + S` | Screenshot Region | Capture selected region to clipboard via `grim` + `slurp` |
| `SUPER + L` | Lock Screen | Lock session with `hyprlock` |

---

## 🔧 Customization & Configuration

### 🖥️ Monitors & Displays
Edit `~/.config/hypr/monitors.lua` or `monitors.conf` to set custom monitor resolutions, refresh rates, and positioning:
```lua
hl.monitor({
    output   = "eDP-1",
    mode     = "1920x1080@144",
    position = "0x0",
    scale    = "1",
})
```
Alternatively, launch `nwg-displays` from terminal to adjust outputs via GUI.

### 🖼️ Wallpaper Management
Launch **Waypaper** from terminal or keybinding:
```bash
waypaper
```
Select any image from `~/.config/hypr/wallpapers` to set wallpaper and update **Wallust** dynamic color palettes.

---

## ❓ Troubleshooting

- **Hyprland failed to parse `hyprland.lua`**:
  Ensure your Hyprland binary supports Lua configurations (Hyprland v0.42+ or hyprland-lua plugin). You can also include standard `.conf` directives using `hyprland.conf` wrapper.
- **Stow conflicts on install**:
  If Stow reports pre-existing non-symlink files, back up or remove the target directory in `~/.config/<module>` and re-run `./install.sh`.
- **Icons/Fonts rendering as boxes**:
  Install JetBrainsMono Nerd Font and Font Awesome:
  ```bash
  sudo pacman -S ttf-jetbrains-mono-nerd ttf-font-awesome
  ```

---

<div align="center">

Crafted with ❤️ for Linux enthusiasts. Feel free to star ⭐️ the repository if you find it useful!

</div>
