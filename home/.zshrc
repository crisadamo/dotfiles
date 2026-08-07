# If you come from bash you might have to change your $PATH.
export PATH=$HOME/bin:/usr/local/bin:$PATH
export PATH="$HOME/.local/bin:$PATH"

if [[ -f "/opt/homebrew/bin/brew" ]] then
  # If you're using macOS, you'll want this enabled
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
[ ! -d $ZINIT_HOME ] && mkdir -p "$(dirname $ZINIT_HOME)"
[ ! -d $ZINIT_HOME/.git ] && git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
source "${ZINIT_HOME}/zinit.zsh"

export FZF_DEFAULT_OPTS=" \
--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
--color=marker:#f5e0dc,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8"

# Install plugings
zinit light zsh-users/zsh-syntax-highlighting
zinit light zsh-users/zsh-completions
zinit light zsh-users/zsh-autosuggestions
zinit light Aloxaf/fzf-tab

zinit snippet OMZP::git
zinit snippet OMZP::jump

# Load completions
autoload -U compinit && compinit
zinit cdreplay -q

# emacs keybindings
bindkey -e

# History
HISTSIZE=5000
HISTFILE=~/.zsh_history
SAVEHIST=$HISTSIZE
HISTDUP=erase
setopt appendhistory
setopt sharehistory
setopt hist_ignore_space
setopt hist_ignore_all_dups
setopt hist_save_no_dups
setopt hist_ignore_dups
setopt hist_find_no_dups

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"
zstyle ':completion:*' menu no
zstyle ':fzf-tab:complete:cd:*' fzf-preview 'ls --color $realpath'
zstyle ':fzf-tab:complete:__zoxide_z:*' fzf-preview 'ls --color $realpath'

# Aliases
alias ls='ls --color'
alias vim='nvim'
alias c='clear'
alias pyweb="python -m http.server"

#export DENO_DIR="$HOME/Library/Caches/deno"
export PATH="$HOME/.bun/bin:$PATH"

# ~/.zshrc
[ -f "$HOME/.config/secrets/shell.env" ] && source "$HOME/.config/secrets/shell.env"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion:
[ -f "$HOME/.vite-plus/env" ] && source "$HOME/.vite-plus/env"

# Shell integrations
autoload -Uz compinit && compinit -C
eval "$(fzf --zsh)"
eval "$(zoxide init --cmd cd zsh)"
if command -v mise >/dev/null 2>&1; then eval "$(mise activate zsh)"; fi
if command -v wt >/dev/null 2>&1; then eval "$(command wt config shell init zsh)"; fi
eval "$(starship init zsh)"
