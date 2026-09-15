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
echo "🖥️  Detected System Package Manager: $PKG_MANAGER"
echo ""
echo "⚠️  PLEASE READ THE FOLLOWING SUMMARY BEFORE PROCEEDING:"
echo "------------------------------------------------------------------------------"
echo ""
echo "1. 📦 SYSTEM PACKAGE INSTALLATION (requires sudo):"
if command -v pacman >/dev/null 2>&1; then
    echo "   Official (pacman):"
    echo "     stow, hyprland, hyprlock, hypridle, kitty, fastfetch, btop, htop,"
    echo "     zsh, waypaper, wallust, xdg-desktop-portal-hyprland, grim, slurp,"
    echo "     wl-clipboard, fzf, wofi, dolphin, brightnessctl, playerctl,"
    echo "     wireplumber, tesseract, kvantum, nwg-look, libnotify, qalculate-gtk,"
    echo "     bibata-cursor-theme, flat-remix-gtk, flat-remix-icon,"
    echo "     ttf-jetbrains-mono-nerd, ttf-font-awesome, papirus-icon-theme"
    echo "   AUR (via yay/paru if installed):"
    echo "     ghostty, wezterm, nwg-displays, noctalia-git"
elif command -v dnf >/dev/null 2>&1; then
    echo "   Packages (dnf):"
    echo "     stow, hyprland, hyprlock, hypridle, kitty, fastfetch, btop, htop,"
    echo "     zsh, waypaper, grim, slurp, wl-clipboard, fzf, wofi, dolphin,"
    echo "     brightnessctl, playerctl, wireplumber-utils, tesseract, libnotify,"
    echo "     kvantum, qalculate-gtk, jetbrains-mono-fonts, fontawesome-fonts, papirus-icon-theme"
elif command -v apt >/dev/null 2>&1; then
    echo "   Base packages (apt):"
    echo "     stow, zsh, fastfetch, btop, htop, grim, slurp, wl-clipboard,"
    echo "     fzf, wofi, dolphin-fm, brightnessctl, playerctl, wireplumber,"
    echo "     tesseract-ocr, qt5-style-kvantum, libnotify-bin, qalculate-gtk,"
    echo "     fonts-jetbrains-mono, fonts-font-awesome, python3-pip, cargo, git, curl, wget"
    echo "   PPA addition:"
    echo "     ppa:cppwm/hyprland (for Hyprland, hyprlock, hypridle)"
    echo "   Python/Cargo tools:"
    echo "     waypaper (pip), wallust (cargo)"
else
    echo "   ⚠️  Manual package installation required (unknown OS)."
fi
echo ""
echo "2. 🐚 SHELL FRAMEWORK INSTALLATION:"
echo "   - Oh-My-Zsh framework (https://ohmyz.sh)"
echo "   - Zsh plugins: zsh-autosuggestions, zsh-syntax-highlighting"
echo ""
echo "3. 🔑 EXECUTABLE PERMISSIONS:"
echo "   - Will run 'chmod +x' on all scripts in: $DOTFILES_DIR/scripts/.local/bin/"
echo ""
echo "4. 🌐 ENVIRONMENT & PATH:"
echo "   - Will append 'export PATH=\"\$HOME/.local/bin:\$PATH\"' to ~/.zshrc or ~/.bashrc if missing."
echo ""
echo "5. 📂 DIRECTORY CREATION:"
echo "   - ~/Pictures/Screenshots   (screenshot save location)"
echo "   - ~/Pictures/wallpapers    (wallpaper directory)"
echo "   - ~/.config, ~/.local/bin, ~/.local/state"
echo ""
echo "6. 🔗 CONFIG SYMLINKING (GNU Stow / ln -sf):"
echo "   Will link configuration directories to ~/.config, ~/.local, and ~/:"
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
echo "     • qt         -> ~/.config/qt5ct, qt6ct & Kvantum"
echo "     • nwg        -> ~/.config/nwg-displays & nwg-look"
echo "     • scripts    -> ~/.local/bin/*"
echo "     • zsh        -> ~/.zshrc"
echo ""
echo "7. 🐚 SHELL & SESSION SETUP:"
echo "   - Will attempt to change default shell to Zsh using 'chsh'."
echo "   - Will attempt to reload active Hyprland session via 'hyprctl reload'."
echo ""
echo "⚡ CAUTION & WARNINGS:"
echo "   - Existing files at target symlink locations WILL be overwritten or replaced."
echo "   - System package installation will prompt for your 'sudo' password."
echo "   - Your default shell will be changed to Zsh if it isn't already."
echo "   - Oh-My-Zsh will be installed to ~/.oh-my-zsh (existing install will be preserved)."
echo "------------------------------------------------------------------------------"
echo ""

if [ "$AUTO_YES" = false ]; then
    read -rp "❓ Do you want to proceed with the installation? [y/N]: " CONFIRM
    case "$CONFIRM" in
        [yY][eE][sS]|[yY])
            echo ""
            echo "✅ Confirmation received. Proceeding with installation..."
            echo ""
            ;;
        *)
            echo "❌ Installation aborted by user."
            exit 0
            ;;
    esac
fi

# ==============================================================================
# STEP 1: Package Installation & System Preparation
# ==============================================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📦 STEP 1/7: Installing system packages..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if command -v pacman >/dev/null 2>&1; then
    echo "📦 Detected Arch Linux (pacman)..."
    CORE_PKGS=(
        stow hyprland hyprlock hypridle
        xdg-desktop-portal-hyprland
        kitty fastfetch btop htop zsh
        waypaper wallust
        grim slurp wl-clipboard
        fzf wofi dolphin libnotify qalculate-gtk
        brightnessctl playerctl wireplumber
        tesseract kvantum nwg-look
        bibata-cursor-theme flat-remix-gtk flat-remix-icon
        ttf-jetbrains-mono-nerd ttf-font-awesome papirus-icon-theme
    )
    
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
        $AUR_HELPER -S --needed --noconfirm ghostty wezterm nwg-displays noctalia-git bibata-cursor-theme-bin 2>/dev/null || true
    else
        echo "💡 Tip: Install 'yay' or 'paru' to automatically install extra AUR packages (ghostty, wezterm, nwg-displays, noctalia-git)."
    fi

elif command -v dnf >/dev/null 2>&1; then
    echo "📦 Detected Fedora (dnf)..."
    CORE_PKGS=(
        stow hyprland hyprlock hypridle
        kitty fastfetch btop htop zsh
        waypaper grim slurp wl-clipboard
        fzf wofi dolphin libnotify qalculate-gtk
        brightnessctl playerctl wireplumber
        tesseract kvantum nwg-look
        jetbrains-mono-fonts fontawesome-fonts papirus-icon-theme
    )
    sudo dnf install -y "${CORE_PKGS[@]}" || true

elif command -v apt >/dev/null 2>&1; then
    echo "📦 Detected Debian/Ubuntu (apt)..."
    CORE_PKGS=(
        stow zsh fastfetch btop htop
        grim slurp wl-clipboard
        fzf wofi dolphin-fm libnotify-bin qalculate-gtk
        brightnessctl playerctl wireplumber
        tesseract-ocr qt5-style-kvantum
        fonts-jetbrains-mono fonts-font-awesome
        python3-pip cargo git curl wget
    )
    sudo apt update
    sudo apt install -y "${CORE_PKGS[@]}" || true

    # Try installing Hyprland via PPA if not present
    if ! command -v hyprland >/dev/null 2>&1; then
        echo "⚡ Hyprland not found. Attempting installation via PPA (ppa:cppwm/hyprland)..."
        sudo apt install -y software-properties-common || true
        sudo add-apt-repository -y ppa:cppwm/hyprland 2>/dev/null || true
        sudo apt update 2>/dev/null || true
        sudo apt install -y hyprland hyprlock hypridle 2>/dev/null || echo "💡 Note: If PPA install failed, download Hyprland binaries from https://github.com/hyprwm/Hyprland/releases"
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
    echo "⚠️  Unknown package manager. Skipping automatic package installation."
fi

echo "✅ Package installation complete."
echo ""

# ==============================================================================
# STEP 2: Oh-My-Zsh & Zsh Plugin Installation
# ==============================================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🐚 STEP 2/7: Installing Oh-My-Zsh & Zsh plugins..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Install Oh-My-Zsh if not present
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "📥 Installing Oh-My-Zsh..."
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || {
        echo "⚠️  Oh-My-Zsh installation failed. Trying with wget..."
        RUNZSH=no CHSH=no sh -c "$(wget -qO- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" || true
    }
else
    echo "✅ Oh-My-Zsh is already installed."
fi

# Install zsh-autosuggestions plugin
ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"
if [ -d "$HOME/.oh-my-zsh" ]; then
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-autosuggestions" ]; then
        echo "📥 Installing zsh-autosuggestions plugin..."
        git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM/plugins/zsh-autosuggestions" 2>/dev/null || true
    else
        echo "✅ zsh-autosuggestions already installed."
    fi

    # Install zsh-syntax-highlighting plugin
    if [ ! -d "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" ]; then
        echo "📥 Installing zsh-syntax-highlighting plugin..."
        git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM/plugins/zsh-syntax-highlighting" 2>/dev/null || true
    else
        echo "✅ zsh-syntax-highlighting already installed."
    fi
fi

echo "✅ Shell framework setup complete."
echo ""

# ==============================================================================
# STEP 3: Executable Permissions Setup
# ==============================================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔑 STEP 3/7: Setting executable permissions..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if [ -d "$DOTFILES_DIR/scripts/.local/bin" ]; then
    chmod +x "$DOTFILES_DIR/scripts/.local/bin/"* 2>/dev/null || true
    echo "✅ Executable permissions set for all scripts in scripts/.local/bin/"
else
    echo "⚠️  scripts/.local/bin/ directory not found, skipping."
fi
echo ""

# ==============================================================================
# STEP 4: Environment & PATH Setup
# ==============================================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🌐 STEP 4/7: Configuring environment & PATH..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

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
        echo "✅ Added ~/.local/bin to PATH in $SHELL_RC"
    else
        echo "✅ ~/.local/bin is already in PATH."
    fi
else
    echo "⚠️  No shell RC file found. Please add 'export PATH=\"\$HOME/.local/bin:\$PATH\"' to your shell config manually."
fi
echo ""

# ==============================================================================
# STEP 5: Directory Creation
# ==============================================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "📂 STEP 5/7: Creating required directories..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

mkdir -p "$HOME/.config"
mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.local/state"
mkdir -p "$HOME/Pictures/Screenshots"
mkdir -p "$HOME/Pictures/wallpapers"

echo "✅ Created directories:"
echo "   • ~/.config"
echo "   • ~/.local/bin"
echo "   • ~/.local/state"
echo "   • ~/Pictures/Screenshots"
echo "   • ~/Pictures/wallpapers"
echo ""

# ==============================================================================
# STEP 6: Config Backup & Symlinking
# ==============================================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🔗 STEP 6/7: Deploying configuration symlinks..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

MODULES=(hypr kitty ghostty wezterm waypaper fastfetch btop htop noctalia gtk qt nwg scripts zsh)

if command -v stow >/dev/null 2>&1; then
    echo "🔗 Linking using GNU Stow..."
    cd "$DOTFILES_DIR"
    for module in "${MODULES[@]}"; do
        if [ -d "$module" ]; then
            stow -R "$module" 2>/dev/null && echo "   ✅ $module" || echo "   ⚠️  $module (stow conflict — check for existing files)"
        else
            echo "   ⏭️  $module (directory not found, skipping)"
        fi
    done
else
    echo "🔗 GNU Stow not found. Falling back to manual symlinking ('ln -sf')..."
    ln -sf "$DOTFILES_DIR/hypr/.config/hypr" "$HOME/.config/hypr" && echo "   ✅ hypr" || true
    ln -sf "$DOTFILES_DIR/kitty/.config/kitty" "$HOME/.config/kitty" && echo "   ✅ kitty" || true
    ln -sf "$DOTFILES_DIR/ghostty/.config/ghostty" "$HOME/.config/ghostty" && echo "   ✅ ghostty" || true
    ln -sf "$DOTFILES_DIR/wezterm/.config/wezterm" "$HOME/.config/wezterm" && echo "   ✅ wezterm" || true
    ln -sf "$DOTFILES_DIR/waypaper/.config/waypaper" "$HOME/.config/waypaper" && echo "   ✅ waypaper" || true
    ln -sf "$DOTFILES_DIR/fastfetch/.config/fastfetch" "$HOME/.config/fastfetch" && echo "   ✅ fastfetch" || true
    ln -sf "$DOTFILES_DIR/btop/.config/btop" "$HOME/.config/btop" && echo "   ✅ btop" || true
    ln -sf "$DOTFILES_DIR/htop/.config/htop" "$HOME/.config/htop" && echo "   ✅ htop" || true
    ln -sf "$DOTFILES_DIR/noctalia/.local/state/noctalia" "$HOME/.local/state/noctalia" && echo "   ✅ noctalia" || true
    ln -sf "$DOTFILES_DIR/gtk/.config/gtk-3.0" "$HOME/.config/gtk-3.0" 2>/dev/null && echo "   ✅ gtk-3.0" || true
    ln -sf "$DOTFILES_DIR/gtk/.config/gtk-4.0" "$HOME/.config/gtk-4.0" 2>/dev/null && echo "   ✅ gtk-4.0" || true
    [ -f "$DOTFILES_DIR/gtk/.gtkrc-2.0" ] && ln -sf "$DOTFILES_DIR/gtk/.gtkrc-2.0" "$HOME/.gtkrc-2.0" 2>/dev/null && echo "   ✅ gtkrc-2.0" || true
    ln -sf "$DOTFILES_DIR/qt/.config/qt5ct" "$HOME/.config/qt5ct" 2>/dev/null && echo "   ✅ qt5ct" || true
    ln -sf "$DOTFILES_DIR/qt/.config/qt6ct" "$HOME/.config/qt6ct" 2>/dev/null && echo "   ✅ qt6ct" || true
    ln -sf "$DOTFILES_DIR/qt/.config/Kvantum" "$HOME/.config/Kvantum" 2>/dev/null && echo "   ✅ Kvantum" || true
    ln -sf "$DOTFILES_DIR/nwg/.config/nwg-displays" "$HOME/.config/nwg-displays" 2>/dev/null && echo "   ✅ nwg-displays" || true
    ln -sf "$DOTFILES_DIR/nwg/.config/nwg-look" "$HOME/.config/nwg-look" 2>/dev/null && echo "   ✅ nwg-look" || true
    ln -sf "$DOTFILES_DIR/zsh/.zshrc" "$HOME/.zshrc" && echo "   ✅ zsh" || true

    # Symlink custom scripts into ~/.local/bin
    if [ -d "$DOTFILES_DIR/scripts/.local/bin" ]; then
        echo "   🔗 Linking scripts to ~/.local/bin/..."
        for script in "$DOTFILES_DIR/scripts/.local/bin/"*; do
            [ -e "$script" ] && ln -sf "$script" "$HOME/.local/bin/$(basename "$script")"
        done
        echo "   ✅ scripts"
    fi
fi
echo ""

# ==============================================================================
# STEP 7: Shell & Session Post-Setup
# ==============================================================================
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🐚 STEP 7/7: Shell & session configuration..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

if command -v zsh >/dev/null 2>&1 && [ "$SHELL" != "$(which zsh)" ]; then
    echo "🐚 Changing default shell to Zsh..."
    chsh -s "$(which zsh)" && echo "✅ Default shell changed to Zsh." || echo "⚠️  Could not change shell automatically. Run 'chsh -s $(which zsh)' manually."
else
    echo "✅ Default shell is already Zsh."
fi

# Reload Hyprland if active
if command -v hyprctl >/dev/null 2>&1 && [ -n "$HYPRLAND_INSTANCE_SIGNATURE" ]; then
    echo "🔄 Reloading active Hyprland session..."
    hyprctl reload && echo "✅ Hyprland reloaded." || true
else
    echo "ℹ️  Hyprland is not currently running. Start/restart Hyprland to apply changes."
fi

echo ""
echo "=============================================================================="
echo " ✨ Hyprland dotfiles setup completed successfully!"
echo "=============================================================================="
echo ""
echo " 📋 Post-install checklist:"
echo "    • Log out and log back in (or reboot) for shell changes to take effect."
echo "    • Start Hyprland from your display manager or TTY."
echo "    • Add wallpapers to ~/Pictures/wallpapers for Waypaper/Noctalia."
echo "    • Run 'fastfetch' to verify your terminal setup."
echo ""
echo " 🎉 Enjoy your new desktop!"
echo ""
