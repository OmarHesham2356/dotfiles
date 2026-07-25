# dotfiles

Hyprland desktop environment configs for Arch Linux.

## What's included

| Package | Description |
|---------|-------------|
| hypr | Hyprland, hypridle, hyprlock |
| waybar | Status bar |
| kitty | Terminal emulator |
| rofi | Application launcher |
| swaync | Notification center |
| fastfetch | System info |
| cava | Audio visualizer |
| yazi | File manager |
| gtk | GTK3/GTK4 dark theme |
| tmux | Terminal multiplexer |
| nvim | LazyVim with pywal |
| opencode | Opencode AI config |
| btop | System monitor with pywal theme |
| zsh | Zsh with oh-my-zsh |
| scripts | Utility scripts |
| wal | Pywal templates |

## Install

```bash
git clone https://github.com/OmarHesham2356/dotfiles.git ~/dotfiles
cd ~/dotfiles

# Install everything
stow hypr waybar kitty rofi swaync fastfetch cava yazi gtk tmux nvim opencode btop zsh scripts wal

# Or install individual packages
stow hypr
stow waybar
```

## Uninstall

```bash
cd ~/dotfiles
stow -D hypr waybar kitty rofi swaync fastfetch cava yazi gtk tmux nvim opencode btop zsh scripts wal
```

## Requirements

```bash
# Hyprland ecosystem
sudo pacman -S hyprland waybar waybar-cava rofi kitty hyprshot hyprpicker hyprlock hypridle wlogout swaync brightnessctl playerctl pavucontrol

# Utilities
sudo pacman -S fastfetch neovim tmux yazi zoxide eza bat btop fzf cliphist wl-clipboard

# Theming
sudo pacman -S ttf-jetbrains-mono-nerd python-pywal16

# Bluetooth
sudo pacman -S bluez bluez-utils
sudo systemctl enable --now bluetooth
```
