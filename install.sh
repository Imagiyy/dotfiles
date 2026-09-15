#!/usr/bin/env bash

# Hyprland Dotfiles Setup & Restoration Script

set -e

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
echo "🚀 Restoring Hyprland Dotfiles from $DOTFILES_DIR..."

# 1. Check Package Manager & Offer Installation
if command -v dnf >/dev/null 2>&1; then
    echo "📦 Detected Fedora (dnf). Installing Stow & core dependencies..."
    sudo dnf install -y stow hyprland kitty fastfetch btop || true
elif command -v pacman >/dev/null 2>&1; then
    echo "📦 Detected Arch Linux (pacman). Installing Stow & core dependencies..."
    sudo pacman -S --noconfirm stow hyprland kitty fastfetch btop || true
elif command -v apt >/dev/null 2>&1; then
    echo "📦 Detected Debian/Ubuntu (apt). Installing Stow..."
    sudo apt update && sudo apt install -y stow || true
fi

# 2. Deploy Config Symlinks
if command -v stow >/dev/null 2>&1; then
    echo "🔗 Symlinking configurations using GNU Stow..."
    cd "$DOTFILES_DIR"
    stow -R hypr kitty ghostty wezterm waypaper fastfetch btop htop noctalia gtk qt nwg scripts zsh
else
    echo "🔗 Symlinking configurations using ln..."
    mkdir -p ~/.config ~/.local/state ~/.local
    ln -sf "$DOTFILES_DIR/hypr/.config/hypr" ~/.config/hypr
    ln -sf "$DOTFILES_DIR/kitty/.config/kitty" ~/.config/kitty
    ln -sf "$DOTFILES_DIR/ghostty/.config/ghostty" ~/.config/ghostty
    ln -sf "$DOTFILES_DIR/wezterm/.config/wezterm" ~/.config/wezterm
    ln -sf "$DOTFILES_DIR/waypaper/.config/waypaper" ~/.config/waypaper
    ln -sf "$DOTFILES_DIR/fastfetch/.config/fastfetch" ~/.config/fastfetch
    ln -sf "$DOTFILES_DIR/btop/.config/btop" ~/.config/btop
    ln -sf "$DOTFILES_DIR/htop/.config/htop" ~/.config/htop
    ln -sf "$DOTFILES_DIR/noctalia/.local/state/noctalia" ~/.local/state/noctalia
    ln -sf "$DOTFILES_DIR/zsh/.zshrc" ~/.zshrc
fi

# 3. Reload Hyprland if active
if command -v hyprctl >/dev/null 2>&1; then
    hyprctl reload || true
fi

echo "✨ Hyprland dotfiles setup completed successfully!"
