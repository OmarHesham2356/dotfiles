export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git z sudo)

source $ZSH/oh-my-zsh.sh

source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source /usr/share/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh

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

export PATH="$HOME/.local/bin:$PATH"
export GTK_THEME="Adwaita-dark"

zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:*:*' fzf-preview 'bat --color=always --style=numbers --line-range=:500 $realpath'
zstyle ':fzf-tab:*' switch-group '<' '>'
zstyle ':fzf-tab:*' fzf-command ftb-tmux-popup
zstyle ':fzf-tab:*' fzf-flags --height=80% --layout=reverse --border --margin=10%,20% --preview-window=right:50%

fetch -l arch
