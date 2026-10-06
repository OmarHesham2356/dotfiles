#!/usr/bin/env bash
# Dependency installer for these dotfiles (Arch + Hyprland).
#
#   bash install.sh
#
# Then log out and back in, pick "Hyprland" at SDDM.
# Switching the login shell needs your password, so it is left to you:
#   chsh -s /usr/bin/zsh "$USER"
set -euo pipefail

STOW_PACKAGES=(
  btop cava fastfetch fontconfig gtk herdr hypr kitty nvim opencode rofi
  scripts swaync tmux wal waybar yazi zsh
)

REPO_PKGS=(
  # --- Hyprland session ---
  hyprland hyprlock hypridle hyprshot hyprpicker hyprcursor
  # --- Desktop shell ---
  waybar rofi rofi-emoji kitty swaync wlogout
  # --- Shell / core ---
  zsh stow git curl unzip jq
  # --- Terminal / editor ---
  neovim tmux lazygit
  # --- Utilities used by binds and scripts ---
  fastfetch btop cava yazi eza bat zoxide fzf cliphist wl-clipboard
  wf-recorder grim slurp mediainfo ouch imagemagick
  # --- Hardware / session helpers referenced by hyprland.lua ---
  playerctl pavucontrol brightnessctl bluez bluez-utils
  networkmanager
  awww blueman polkit-gnome gvfs power-profiles-daemon
  # --- Fonts, cursors and icons ---
  ttf-jetbrains-mono-nerd gnome-themes-extra papirus-icon-theme
)

AUR_PKGS=(
  # python-pywal16, NOT the AUR "python-pywal" (3.3.0, abandoned 2017 release
  # that ships no templates at all -- every colours-* file comes out empty).
  python-pywal16
  # Repo name is "bibata-cursor-theme", not the AUR "ttf-bibata-cursor-theme".
  bibata-cursor-theme
)

clone_shallow() {
  local url="$1" dest="$2"
  [ -d "$dest" ] && { echo "  skip $dest (exists)"; return; }
  echo "  clone $dest"
  git clone --depth 1 "$url" "$dest"
}

echo "==> 1/5  Official repository packages"
sudo pacman -Syu --needed --noconfirm "${REPO_PKGS[@]}"

echo "==> 2/5  AUR packages"
yay -S --needed --noconfirm "${AUR_PKGS[@]}"

echo "==> 3/5  zsh plugins (shallow clones)"
clone_shallow https://github.com/ohmyzsh/ohmyzsh.git "$HOME/.oh-my-zsh"
clone_shallow https://github.com/zsh-users/zsh-autosuggestions.git \
  "$HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
# .zshrc sources fast-syntax-highlighting (not zsh-syntax-highlighting),
# plus zsh-completions and zsh-history-substring-search via the plugins array.
clone_shallow https://github.com/zdharma-continuum/fast-syntax-highlighting.git \
  "$HOME/.oh-my-zsh/custom/plugins/fast-syntax-highlighting"
clone_shallow https://github.com/zsh-users/zsh-completions.git \
  "$HOME/.oh-my-zsh/custom/plugins/zsh-completions"
clone_shallow https://github.com/zsh-users/zsh-history-substring-search.git \
  "$HOME/.oh-my-zsh/custom/plugins/zsh-history-substring-search"
clone_shallow https://github.com/zdharma-continuum/fzf-tab.git \
  "$HOME/.oh-my-zsh/custom/plugins/fzf-tab"
clone_shallow https://github.com/tmux-plugins/tpm.git \
  "$HOME/.local/share/tmux/plugins/tpm"

echo "==> 4/5  Services"
sudo systemctl enable --now bluetooth.service
sudo systemctl enable --now power-profiles-daemon.service

echo "==> 5/5  Stow configs and generate the pywal theme"
# Run from the repo root so stow resolves the package dirs.
cd "$(dirname "$(readlink -f "$0")")"
stow --restow "${STOW_PACKAGES[@]}"

# Must run after the stow: pywal only picks up
# wal/.config/wal/templates/colors-hyprland.lua once it is linked into
# ~/.config/wal/templates. That template is a Lua module (hyprland.lua is read
# with loadfile()); stock pywal emits $color5 as rgba(...), which is not a valid
# Lua value, and hyprland appends its own alpha byte inside rgba().
wal --theme "${WAL_THEME:-catppuccin-mocha}" -q
"$HOME/.local/bin/tmux-theme-gen"

echo
echo "Done. Log out, pick Hyprland at SDDM, then run: chsh -s /usr/bin/zsh \"\$USER\""
