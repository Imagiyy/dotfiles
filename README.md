<div align="center">

# ✨ Aesthetic Hyprland Dotfiles

[![OS - Arch Linux](https://img.shields.io/badge/OS-Arch%20%7C%20Fedora%20%7C%20Ubuntu-blue?style=for-the-badge&logo=linux)](https://archlinux.org)
[![WM - Hyprland](https://img.shields.io/badge/WM-Hyprland-58E189?style=for-the-badge&logo=hyprland)](https://hyprland.org)
[![Config - Lua](https://img.shields.io/badge/Config-Lua-000080?style=for-the-badge&logo=lua)](https://lua.org)
[![Deployment - GNU Stow](https://img.shields.io/badge/Deployment-GNU%20Stow-informational?style=for-the-badge&logo=gnu)](https://www.gnu.org/software/stow/)
[![Shell - Zsh](https://img.shields.io/badge/Shell-Zsh%20%2B%20Oh--My--Zsh-purple?style=for-the-badge&logo=zsh)](https://ohmyz.sh)

A complete, modern, and beautifully crafted Hyprland ecosystem configuration featuring Lua-based window management, dynamic theme generation, shell state persistence with **Noctalia**, wallpaper switching via **Waypaper**, and multiple tuned terminal environments.

</div>

---

## 🌟 Key Features

- **🚀 Hyprland Lua Configuration (`hyprland.lua`)**: Modular, clean, and declarative window management configuration written in Lua.
- **🎨 Dynamic Theming & Color Schemes**: Integrated with **Wallust** and **Noctalia** state manager for fluid wallpaper-based palette generation. Includes **Catppuccin** Kvantum themes for Qt apps.
- **🖼️ Waypaper Wallpaper Engine**: Integrated wallpaper selector supporting animated and static wallpapers.
- **💻 Multi-Terminal Suite**: Preconfigured settings for **Kitty**, **Ghostty**, and **Wezterm**.
- **📊 System Monitoring & Information**: Modern **Fastfetch** configs alongside custom styled **Btop** and **Htop**.
- **🐚 Prompt & Shell Setup**: Custom **Zsh** environment powered by **Oh-My-Zsh** with `zsh-autosuggestions`, `zsh-syntax-highlighting`, `fzf` fuzzy history, and **Oh-My-Posh** prompt rendering.
- **🖥️ Multi-Monitor & Display Management**: Easily configure output resolution and scaling using **nwg-displays**, **nwg-look**, and `monitors.lua`.
- **🔒 Session Management**: Automatic idle detection with **hypridle** and screen locking with **hyprlock**.
- **📸 Screenshots & OCR**: Region selection, fullscreen capture, and OCR-to-clipboard via `grim`, `slurp`, and `tesseract`.

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
├── qt/                 # Qt5ct / Qt6ct / Kvantum styling (Catppuccin themes)
├── nwg/                # nwg-displays & nwg-look configuration
├── scripts/            # Custom helper binaries & utilities (~/.local/bin)
├── zsh/                # Custom .zshrc with Oh-My-Zsh + Oh-My-Posh integration
└── install.sh          # Fully automated setup & deployment script
```

---

## 🚀 Quick Start Installation

Run the automated restoration script directly from your terminal:

```bash
git clone https://github.com/Imagiyy/dotfiles.git ~/dotfiles
cd ~/dotfiles
chmod +x install.sh
./install.sh
```

> **Note:** The script will display a detailed summary of **everything** it will do and ask for `y/N` confirmation before making any changes. Nothing is hidden.
>
> Use `./install.sh -y` to skip the confirmation prompt (for automated/headless setups).

### What `install.sh` handles automatically (7 steps):

| Step | Action | Details |
| :---: | :--- | :--- |
| 1 | **📦 Package Installation** | Detects `pacman`/`dnf`/`apt` and installs all required packages including Hyprland, terminals, utilities, fonts, and theme engines. On Ubuntu, adds PPA and installs via `pip`/`cargo`. |
| 2 | **🐚 Oh-My-Zsh & Plugins** | Installs Oh-My-Zsh framework, `zsh-autosuggestions`, and `zsh-syntax-highlighting` plugins. |
| 3 | **🔑 Permissions** | Makes all scripts in `scripts/.local/bin/` executable (`oh-my-posh`, `hypr-keybinds`, etc.). |
| 4 | **🌐 PATH Setup** | Ensures `~/.local/bin` is exported in your `$PATH`. |
| 5 | **📂 Directories** | Creates `~/Pictures/Screenshots` and `~/Pictures/wallpapers`. |
| 6 | **🔗 Symlinking** | Deploys all 14 config modules via GNU Stow (or `ln -sf` fallback) with per-module ✅/⚠️ status. |
| 7 | **🐚 Shell & Session** | Changes default shell to Zsh and reloads Hyprland if active. |

---

## 📦 Package Dependency Matrix

| Component | Arch Linux (`pacman` / AUR) | Fedora (`dnf`) | Debian / Ubuntu (`apt` / `pip` / `cargo`) |
| :--- | :--- | :--- | :--- |
| **Window Manager** | `hyprland` | `hyprland` | `hyprland` *(PPA: cppwm/hyprland)* |
| **Screen Lock & Idle** | `hyprlock`, `hypridle` | `hyprlock`, `hypridle` | `hyprlock`, `hypridle` *(PPA)* |
| **Portal** | `xdg-desktop-portal-hyprland` | — | — |
| **Dotfile Deployment** | `stow` | `stow` | `stow` |
| **Terminals** | `kitty`, `ghostty` *(AUR)*, `wezterm` *(AUR)* | `kitty` | `kitty`, `ghostty` / `wezterm` *(GitHub .deb)* |
| **App Launcher** | `wofi` | `wofi` | `wofi` |
| **File Manager** | `dolphin` | `dolphin` | `dolphin-fm` |
| **Wallpaper & Colors** | `waypaper`, `wallust` | `waypaper` | `waypaper` *(pip)*, `wallust` *(cargo)* |
| **Screen Capture & OCR** | `grim`, `slurp`, `wl-clipboard`, `tesseract` | `grim`, `slurp`, `wl-clipboard`, `tesseract` | `grim`, `slurp`, `wl-clipboard`, `tesseract-ocr` |
| **Media & Brightness** | `brightnessctl`, `playerctl`, `wireplumber` | `brightnessctl`, `playerctl`, `wireplumber` | `brightnessctl`, `playerctl`, `wireplumber` |
| **System Monitors** | `fastfetch`, `btop`, `htop` | `fastfetch`, `btop`, `htop` | `fastfetch`, `btop`, `htop` |
| **Fuzzy Finder** | `fzf` | `fzf` | `fzf` |
| **Shell Framework** | *Oh-My-Zsh (auto-installed)* | *Oh-My-Zsh (auto-installed)* | *Oh-My-Zsh (auto-installed)* |
| **Qt Theming** | `kvantum`, `nwg-look` | `kvantum`, `nwg-look` | `qt5-style-kvantum` |
| **Fonts** | `ttf-jetbrains-mono-nerd`, `ttf-font-awesome`, `papirus-icon-theme` | `jetbrains-mono-fonts`, `fontawesome-fonts`, `papirus-icon-theme` | `fonts-jetbrains-mono`, `fonts-font-awesome` |

---

## ⌨️ Keybindings Cheat Sheet

### Core Actions

| Key Combination | Action |
| :--- | :--- |
| `SUPER + Return` | Launch terminal (Kitty) |
| `SUPER + Q` | Close focused window |
| `SUPER + E` | Open file manager (Dolphin) |
| `SUPER + D` | Toggle Noctalia launcher |
| `SUPER + V` | Toggle floating mode |
| `SUPER + P` | Pseudo-tile (Dwindle) |
| `SUPER + J` | Toggle split direction (Dwindle) |
| `Home` | Toggle fullscreen |
| `SUPER + L` | Maximize window (monocle mode) |

### Window Navigation

| Key Combination | Action |
| :--- | :--- |
| `SUPER + ←/→/↑/↓` | Move focus (left / right / up / down) |
| `SUPER + 1–9, 0` | Switch to workspace 1–10 |
| `SUPER + SHIFT + 1–9, 0` | Move window to workspace 1–10 |
| `SUPER + Mouse Scroll` | Scroll through workspaces |
| `SUPER + LMB Drag` | Move window |
| `SUPER + RMB Drag` | Resize window |
| `ALT + Tab` | Cycle windows on current workspace |
| `SUPER + Tab` | Switch windows across all workspaces (Noctalia) |

### Screenshots & Capture

| Key Combination | Action |
| :--- | :--- |
| `SUPER + SHIFT + S` | Fullscreen screenshot (save + clipboard) |
| `Print` | Region selection screenshot (save + clipboard) |
| `SUPER + Print` | OCR region to clipboard (via Tesseract) |

### Application Shortcuts

| Key Combination | Action |
| :--- | :--- |
| `SUPER + C` | Launch Google Chrome |
| `SUPER + B` | Launch Brave Browser (Flatpak) |
| `SUPER + O` | Launch Obsidian (Flatpak) |
| `SUPER + A` | Launch Antigravity IDE |
| `SUPER + M` | Launch MATLAB |
| `SUPER + S` | Toggle Noctalia Settings |
| `SUPER + H` | Show keybindings cheat sheet |

### Media & Hardware Keys

| Key | Action |
| :--- | :--- |
| `XF86AudioRaiseVolume` / `LowerVolume` | Volume up / down (5%) |
| `XF86AudioMute` | Toggle mute |
| `XF86AudioMicMute` | Toggle mic mute |
| `XF86MonBrightnessUp` / `Down` | Brightness up / down (5%) |
| `XF86AudioNext` / `Prev` / `Play` | Media controls (playerctl) |
| `XF86Calculator` | Open Qalculate |

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
Wallpapers are sourced from `~/Pictures/wallpapers`. Add your images to this directory, then:
- **Noctalia**: Wallpaper rotation is automatic (configurable interval in Noctalia settings).
- **Waypaper**: Launch `waypaper` from terminal to pick wallpapers via GUI.
- **Wallust**: Dynamic color palettes are generated from the active wallpaper automatically.

### 🎨 Qt & GTK Theming
- **GTK**: Configured via `~/.config/gtk-3.0` and `gtk-4.0`. Use `nwg-look` to change GTK themes visually.
- **Qt**: Themed via **Kvantum** with bundled **Catppuccin Mocha/Latte** themes. Adjust in `qt5ct` or `qt6ct`.

---

## ❓ Troubleshooting

| Problem | Solution |
| :--- | :--- |
| **Hyprland fails to parse `hyprland.lua`** | Ensure Hyprland v0.42+ with Lua support. Older versions require `hyprland.conf` format. |
| **Stow conflicts on install** | Remove or back up existing non-symlink files in `~/.config/<module>` and re-run `./install.sh`. |
| **Icons/Fonts render as boxes** | Install Nerd Fonts: `sudo pacman -S ttf-jetbrains-mono-nerd ttf-font-awesome` (Arch) or equivalent for your distro. |
| **Oh-My-Zsh errors on shell start** | Re-run `./install.sh` or manually install: `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"` |
| **`fzf` key bindings not working** | Ensure `fzf` is installed: `sudo pacman -S fzf` / `sudo apt install fzf`. |
| **Screenshots fail silently** | Ensure `~/Pictures/Screenshots/` exists (created by `install.sh`) and `grim`, `slurp`, `wl-clipboard` are installed. |
| **OCR screenshot gives empty clipboard** | Ensure `tesseract` is installed: `sudo pacman -S tesseract` / `sudo apt install tesseract-ocr`. |
| **Volume/Brightness keys not working** | Ensure `wireplumber`, `brightnessctl`, and `playerctl` are installed. |
| **Kvantum Qt theme not applying** | Set `QT_STYLE_OVERRIDE=kvantum` in your environment, or configure in `qt5ct` / `qt6ct`. |

---

<div align="center">

Crafted with ❤️ for Linux enthusiasts. Feel free to star ⭐️ the repository if you find it useful!

</div>
