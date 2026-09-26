# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# fastfetch produces console output on startup; quiet mode suppresses the
# instant-prompt warning while keeping instant prompt enabled.
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet
# gitstatusd fix: patched ~/.oh-my-zsh/custom/themes/powerlevel10k/gitstatus/gitstatus.plugin.zsh
# (setopt monitor || return -> setopt monitor 2>/dev/null || true) for zsh 5.9+ compat.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git z sudo)

source $ZSH/oh-my-zsh.sh

# Plugins live in oh-my-zsh's custom directory on Arch (not /usr/share/zsh).
# Guarded so a missing plugin degrades quietly instead of erroring every shell.
for _plugin in zsh-autosuggestions zsh-syntax-highlighting; do
  [[ -r "$ZSH_CUSTOM/plugins/$_plugin/$_plugin.zsh" ]] && source "$ZSH_CUSTOM/plugins/$_plugin/$_plugin.zsh"
done
unset _plugin

[[ -r "$ZSH_CUSTOM/plugins/fzf-tab/fzf-tab.plugin.zsh" ]] && source "$ZSH_CUSTOM/plugins/fzf-tab/fzf-tab.plugin.zsh"

# fzf-tab must be sourced after compinit
autoload -Uz compinit && compinit

alias lg='lazygit'


# Arch Linux
alias update='sudo pacman -Syu && yay -Sua'
alias install='yay -S'
alias remove='sudo pacman -Rns'
alias search='yay -Ss'
alias cleanup='sudo pacman -Rns $(pacman -Qtdq)'

# Git
alias gs='git status'
alias gp='git push'
alias gl='git pull'
alias gaa='git add -A'
alias gcm='git commit -m'

# Quick access
alias ..='cd ..'
alias ...='cd ../..'
alias ls='eza --icons'
alias ll='eza -lah --icons --git'
alias lt='eza -lah --icons --tree --level=2'
alias ports='ss -tlnp'

[[ -f "$HOME/.cache/wal/fzf-default-opts" ]] && export FZF_DEFAULT_OPTS="$(cat "$HOME/.cache/wal/fzf-default-opts") --height=80% --layout=reverse"

eval "$(zoxide init zsh)"

# ~/.local/bin is also exported system-wide via /etc/environment so that GUI
# sessions (Hyprland keybinds) find the helper scripts. Guard against a dup.
if [[ ":$PATH:" != *":$HOME/.local/bin:"* ]]; then
  export PATH="$HOME/.local/bin:$PATH"
fi
export GTK_THEME="Adwaita-dark"

zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:*:*' fzf-preview 'bat --color=always --style=numbers --line-range=:500 $realpath'
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*' fzf-flags --height=80% --layout=reverse --border --margin=10%,20% --preview-window=right:50%

# Fastfetch on interactive shell startup
if [[ -o interactive ]]; then
    fastfetch
fi

# To customize prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh
