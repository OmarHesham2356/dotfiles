# Console I/O is only safe *above* the instant prompt preamble below: output emitted
# after it gets captured, which makes Powerlevel10k report "console output during zsh
# initialization" and jump the prompt down when it finally renders. fastfetch is the
# only such command here, so it runs first.
if [[ -o interactive ]] && command -v fastfetch >/dev/null 2>&1; then
  fastfetch
fi

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
# gitstatusd fix: patched ~/.oh-my-zsh/custom/themes/powerlevel10k/gitstatus/gitstatus.plugin.zsh
# (setopt monitor || return -> setopt monitor 2>/dev/null || true) for zsh 5.9+ compat.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git z sudo zsh-completions zsh-history-substring-search)

# Powerlevel10k user config. Must be sourced *before* oh-my-zsh: the theme reads
# POWERLEVEL9K_* (notably POWERLEVEL9K_INSTANT_PROMPT) while it sets up the instant
# prompt preamble, so sourcing this at the end of the file silently discards it.
# To customize the prompt, run `p10k configure` or edit ~/.p10k.zsh.
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

source $ZSH/oh-my-zsh.sh

# Plugins live in oh-my-zsh's custom directory on Arch (not /usr/share/zsh).
# Guarded so a missing plugin degrades quietly instead of erroring every shell.
for _plugin in zsh-autosuggestions fast-syntax-highlighting; do
  [[ -r "$ZSH_CUSTOM/plugins/$_plugin/$_plugin.zsh" ]] && source "$ZSH_CUSTOM/plugins/$_plugin/$_plugin.zsh"
done
unset _plugin

# History substring search - bind keys
[[ -r "$ZSH_CUSTOM/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh" ]] && source "$ZSH_CUSTOM/plugins/zsh-history-substring-search/zsh-history-substring-search.zsh"

[[ -r "$ZSH_CUSTOM/plugins/fzf-tab/fzf-tab.plugin.zsh" ]] && source "$ZSH_CUSTOM/plugins/fzf-tab/fzf-tab.plugin.zsh"

# fzf-tab must be sourced after compinit
fpath+=${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions/src
autoload -Uz compinit && compinit -u

alias lg='lazygit'
alias hr='herdr'
alias oc='opencode'

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

# .NET SDK (user-local install, no root needed). ~/.local/bin is also on the
# system PATH, so GUI apps (VS Code) pick up the dotnet symlink from there.
export DOTNET_ROOT="$HOME/.dotnet"
if [[ ":$PATH:" != *":$HOME/.dotnet:"* ]]; then
  export PATH="$HOME/.dotnet:$PATH"
fi

# direnv auto-loads a folder's .envrc on cd (and reverts it on leave).
# Guarded so a missing direnv is a no-op rather than a startup error.
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

export GTK_THEME="Adwaita-dark"

zstyle ':completion:*:git-checkout:*' sort false
zstyle ':completion:*:descriptions' format '[%d]'
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'eza -1 --color=always $realpath'
zstyle ':fzf-tab:complete:*:*' fzf-preview 'bat --color=always --style=numbers --line-range=:500 $realpath'
zstyle ':fzf-tab:*' switch-group '<' '>'
# Use regular fzf in the terminal instead of tmux popup for better integration
zstyle ':fzf-tab:*' fzf-command fzf
zstyle ':fzf-tab:*' fzf-flags --height=60% --layout=reverse --border=rounded --margin=1% --preview-window=right:50% --info=inline --pointer='▌' --marker='✓'

# History settings
export HISTSIZE=1000000
export SAVEHIST=1000000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS

# Better completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no

# History substring search bindings
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down

# FZF options
export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git 2>/dev/null || find . -type f -not -path "*/\.git/*" 2>/dev/null'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git 2>/dev/null || find . -type d -not -path "*/\.git/*" 2>/dev/null'
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"
eval "$(atuin init zsh --disable-up-arrow)"
