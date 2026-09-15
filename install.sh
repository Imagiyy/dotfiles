#!/usr/bin/env bash

# ==============================================================================
# Hyprland Dotfiles Setup & Automated Restoration Script
# ==============================================================================

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

AUTO_YES=false
for arg in "$@"; do
    if [[ "$arg" == "-y" || "$arg" == "--yes" ]]; then
        AUTO_YES=true
    fi
done

# Detect OS & Package Manager
PKG_MANAGER=""
if command -v pacman >/dev/null 2>&1; then
    PKG_MANAGER="pacman (Arch Linux)"
elif command -v dnf >/dev/null 2>&1; then
    PKG_MANAGER="dnf (Fedora)"
elif command -v apt >/dev/null 2>&1; then
    PKG_MANAGER="apt (Debian/Ubuntu)"
else
    PKG_MANAGER="Unknown"
fi

echo "=============================================================================="
echo " 🚀 Hyprland Dotfiles Setup & Restoration Script"
echo "=============================================================================="
echo ""
echo "📍 Dotfiles Location: $DOTFILES_DIR"
echo "🖥️ Detected System Package Manager: $PKG_MANAGER"
echo ""
echo "⚠️  PLEASE READ THE FOLLOWING SUMMARY BEFORE PROCEEDING:"
echo "------------------------------------------------------------------------------"
echo "1. 📦 System Package Installation (requires sudo):"
if command -v pacman >/dev/null 2>&1; then
    echo "   - Official packages: stow, hyprland, kitty, fastfetch, btop, htop, zsh, waypaper, wallust, xdg-desktop-portal-hyprland, grim, slurp, wl-clipboard, fonts"
    echo "   - AUR packages (via yay/paru if installed): ghostty, wezterm, nwg-displays, noctalia-git"
elif command -v dnf >/dev/null 2>&1; then
    echo "   - Packages: stow, hyprland, kitty, fastfetch, btop, htop, zsh, waypaper, grim, slurp, wl-clipboard, fonts"
elif command -v apt >/dev/null 2>&1; then
    echo "   - Base packages: stow, zsh, fastfetch, btop, htop, grim, slurp, wl-clipboard, fonts, python3-pip, cargo"
    echo "   - PPA addition: ppa:cppwm/hyprland (for Hyprland)"
    echo "   - Python/Cargo tools: waypaper (via pip), wallust (via cargo)"
else
    echo "   - Manual package installation required for unknown OS."
fi
echo ""
echo "2. 🔑 Executable Permissions:"
echo "   - Will run 'chmod +x' on all helper scripts in: $DOTFILES_DIR/scripts/.local/bin/"
echo ""
echo "3. 🌐 Environment & PATH:"
echo "   - Will append 'export PATH=\"\$HOME/.local/bin:\$PATH\"' to your ~/.zshrc or ~/.bashrc if missing."
echo ""
echo "4. 🔗 Config Symlinking (GNU Stow / ln -sf):"
echo "   - Will link configuration directories to ~/.config, ~/.local, and ~/:"
echo "     • hypr       -> ~/.config/hypr"
echo "     • kitty      -> ~/.config/kitty"
echo "     • ghostty    -> ~/.config/ghostty"
echo "     • wezterm    -> ~/.config/wezterm"
echo "     • waypaper   -> ~/.config/waypaper"
echo "     • fastfetch  -> ~/.config/fastfetch"
echo "     • btop       -> ~/.config/btop"
echo "     • htop       -> ~/.config/htop"
echo "     • noctalia   -> ~/.local/state/noctalia"
echo "     • gtk        -> ~/.config/gtk-3.0 & gtk-4.0"
echo "     • qt         -> ~/.config/qt5ct"
echo "     • nwg        -> ~/.config/nwg-displays"
echo "     • scripts    -> ~/.local/bin/*"
echo "     • zsh        -> ~/.zshrc"
echo ""
echo "5. 🐚 Shell & Session Setup:"
echo "   - Will attempt to change default shell to Zsh using 'chsh' (if Zsh is available)."
echo "   - Will attempt to reload active Hyprland session via 'hyprctl reload'."
echo ""
echo "⚡ CAUTION & WARNINGS:"
echo "   - Existing files at target symlink locations may be overwritten or replaced by Stow links."
echo "   - System package installation will prompt for your 'sudo' password."
echo "------------------------------------------------------------------------------"
echo ""

if [ "$AUTO_YES" = false ]; then
    read -rp "❓ Do you want to proceed with the installation? [y/N]: " CONFIRM
    case "$CONFIRM" in
        [yY][eE][sS]|[yY])
            echo "✅ Confirmation received. Proceeding with installation..."
            echo ""
            ;;
        *)
            echo "❌ Installation aborted by user."
            exit 0
            ;;
    esac
fi

# ------------------------------------------------------------------------------
# 1. Package Installation & System Preparation
# ------------------------------------------------------------------------------
echo "📦 Checking package manager and installing dependencies..."

if command -v pacman >/dev/null 2>&1; then
    echo "📦 Detected Arch Linux (pacman)..."
    CORE_PKGS=(stow hyprland kitty fastfetch btop htop zsh waypaper wallust xdg-desktop-portal-hyprland grim slurp wl-clipboard ttf-jetbrains-mono-nerd ttf-font-awesome papirus-icon-theme)
    
    echo "Installing core official packages..."
    sudo pacman -S --needed --noconfirm "${CORE_PKGS[@]}" || true
    
    # Check for AUR helper for AUR-specific packages if needed
    AUR_HELPER=""
    if command -v yay >/dev/null 2>&1; then
        AUR_HELPER="yay"
    elif command -v paru >/dev/null 2>&1; then
        AUR_HELPER="paru"
    fi

    if [ -n "$AUR_HELPER" ]; then
        echo "📦 Installing AUR dependencies with $AUR_HELPER..."
        $AUR_HELPER -S --needed --noconfirm ghostty wezterm nwg-displays noctalia-git 2>/dev/null || true
    else
        echo "💡 Tip: Install 'yay' or 'paru' to automatically install extra AUR packages (ghostty, wezterm, nwg-displays)."
    fi

elif command -v dnf >/dev/null 2>&1; then
    echo "📦 Detected Fedora (dnf)..."
    CORE_PKGS=(stow hyprland kitty fastfetch btop htop zsh waypaper grim slurp wl-clipboard jetbrains-mono-fonts fontawesome-fonts papirus-icon-theme)
    sudo dnf install -y "${CORE_PKGS[@]}" || true

elif command -v apt >/dev/null 2>&1; then
    echo "📦 Detected Debian/Ubuntu (apt)..."
    CORE_PKGS=(stow zsh fastfetch btop htop grim slurp wl-clipboard fonts-jetbrains-mono fonts-font-awesome python3-pip cargo git curl wget)
    sudo apt update
    sudo apt install -y "${CORE_PKGS[@]}" || true

    # Try installing Hyprland via PPA if not present
    if ! command -v hyprland >/dev/null 2>&1; then
        echo "⚡ Hyprland not found. Attempting installation via PPA (ppa:cppwm/hyprland)..."
        sudo apt install -y software-properties-common || true
        sudo add-apt-repository -y ppa:cppwm/hyprland 2>/dev/null || true
        sudo apt update 2>/dev/null || true
        sudo apt install -y hyprland 2>/dev/null || echo "💡 Note: If PPA install failed, download Hyprland binaries from https://github.com/hyprwm/Hyprland/releases"
    fi

    # Install Waypaper via pip if missing
    if ! command -v waypaper >/dev/null 2>&1; then
        echo "🐍 Installing Waypaper via pip..."
        pip3 install --user waypaper 2>/dev/null || pip install --user waypaper 2>/dev/null || true
    fi

    # Install Wallust via cargo if missing
    if ! command -v wallust >/dev/null 2>&1 && command -v cargo >/dev/null 2>&1; then
        echo "🦀 Installing Wallust via cargo..."
        cargo install wallust 2>/dev/null || true
    fi
else
    echo "⚠️ Unknown package manager. Skipping automatic package installation."
fi

# ------------------------------------------------------------------------------
# 2. Executable Permissions Setup
# ------------------------------------------------------------------------------
echo "🔑 Setting executable permissions for helper scripts..."
if [ -d "$DOTFILES_DIR/scripts/.local/bin" ]; then
    chmod +x "$DOTFILES_DIR/scripts/.local/bin/"* 2>/dev/null || true
fi

# ------------------------------------------------------------------------------
# 3. Environment & PATH Setup
# ------------------------------------------------------------------------------
echo "🌐 Ensuring ~/.local/bin is in PATH..."
mkdir -p "$HOME/.local/bin"

SHELL_RC=""
if [ -f "$HOME/.zshrc" ]; then
    SHELL_RC="$HOME/.zshrc"
elif [ -f "$HOME/.bashrc" ]; then
    SHELL_RC="$HOME/.bashrc"
fi

if [ -n "$SHELL_RC" ]; then
    if ! grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$SHELL_RC" 2>/dev/null; then
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$SHELL_RC"
        echo "✅ Added ~/.local/bin to $SHELL_RC"
    fi
fi

# ------------------------------------------------------------------------------
# 4. Config Backup & Symlinking
# ------------------------------------------------------------------------------
echo "🔗 Deploying configuration symlinks..."

MODULES=(hypr kitty ghostty wezterm waypaper fastfetch btop htop noctalia gtk qt nwg scripts zsh)

# Create backup of conflicting non-symlink directories if necessary
mkdir -p "$HOME/.config" "$HOME/.local/bin" "$HOME/.local/state"

if command -v stow >/dev/null 2>&1; then
    echo "🔗 Linking using GNU Stow..."
    cd "$DOTFILES_DIR"
    for module in "${MODULES[@]}"; do
        if [ -d "$module" ]; then
            stow -R "$module" || echo "⚠️ Warning: Stow failed for module $module, continuing..."
        fi
    done
else
    echo "🔗 GNU Stow not found. Falling back to manual symlinking ('ln -sf')..."
    ln -sf "$DOTFILES_DIR/hypr/.config/hypr" "$HOME/.config/hypr"
    ln -sf "$DOTFILES_DIR/kitty/.config/kitty" "$HOME/.config/kitty"
    ln -sf "$DOTFILES_DIR/ghostty/.config/ghostty" "$HOME/.config/ghostty"
    ln -sf "$DOTFILES_DIR/wezterm/.config/wezterm" "$HOME/.config/wezterm"
    ln -sf "$DOTFILES_DIR/waypaper/.config/waypaper" "$HOME/.config/waypaper"
    ln -sf "$DOTFILES_DIR/fastfetch/.config/fastfetch" "$HOME/.config/fastfetch"
    ln -sf "$DOTFILES_DIR/btop/.config/btop" "$HOME/.config/btop"
    ln -sf "$DOTFILES_DIR/htop/.config/htop" "$HOME/.config/htop"
    ln -sf "$DOTFILES_DIR/noctalia/.local/state/noctalia" "$HOME/.local/state/noctalia"
    ln -sf "$DOTFILES_DIR/gtk/.config/gtk-3.0" "$HOME/.config/gtk-3.0" 2>/dev/null || true
    ln -sf "$DOTFILES_DIR/gtk/.config/gtk-4.0" "$HOME/.config/gtk-4.0" 2>/dev/null || true
    ln -sf "$DOTFILES_DIR/qt/.config/qt5ct" "$HOME/.config/qt5ct" 2>/dev/null || true
    ln -sf "$DOTFILES_DIR/nwg/.config/nwg-displays" "$HOME/.config/nwg-displays" 2>/dev/null || true
    ln -sf "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc"
    
    # Symlink custom scripts into ~/.local/bin
    if [ -d "$DOTFILES_DIR/scripts/.local/bin" ]; then
        for script in "$DOTFILES_DIR/scripts/.local/bin/"*; do
            [ -e "$script" ] && ln -sf "$script" "$HOME/.local/bin/$(basename "$script")"
        done
    fi
fi

# ------------------------------------------------------------------------------
# 5. Shell & Session Post-Setup
# ------------------------------------------------------------------------------
if command -v zsh >/dev/null 2>&1 && [ "$SHELL" != "$(which zsh)" ]; then
    echo "🐚 Zsh detected! Changing default shell to Zsh..."
    chsh -s "$(which zsh)" || echo "⚠️ Could not automatically change shell. Run 'chsh -s $(which zsh)' manually."
fi

# Reload Hyprland if active
if command -v hyprctl >/dev/null 2>&1 && [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    echo "🔄 Reloading active Hyprland session..."
    hyprctl reload || true
fi

echo ""
echo "✨ Hyprland dotfiles setup completed successfully!"
echo "🎉 Log out and log back in (or start Hyprland) to enjoy your setup!"

