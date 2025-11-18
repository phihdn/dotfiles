# ============================================================================
# FAST ZSH CONFIGURATION WITH ZINIT
# ============================================================================
# Optimized for speed with minimal plugins and lazy loading
# ============================================================================

# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
#   source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
# fi

# ============================================================================
# ZINIT PLUGIN MANAGER SETUP
# ============================================================================

# Load zinit (should be installed by bootstrap script)
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ -f "$ZINIT_HOME/zinit.zsh" ]]; then
  source "$ZINIT_HOME/zinit.zsh"
else
  echo "⚠️  Zinit not found. Please run the bootstrap script to install it."
  echo "   Run: ./bootstrap.sh"
  # Create a dummy function to prevent errors
  zinit() { echo "Zinit not available. Run bootstrap script first. Skipping: $*" }
fi

# ============================================================================
# ESSENTIAL PLUGINS (MINIMAL & FAST)
# ============================================================================

# Fast syntax highlighting (turbo mode)
zinit wait lucid for \
  atinit"ZINIT[COMPINIT_OPTS]=-C; zicompinit; zicdreplay" \
    zdharma-continuum/fast-syntax-highlighting \
  atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
  blockf \
    zsh-users/zsh-completions

# ============================================================================
# ENVIRONMENT VARIABLES
# ============================================================================

export GIT_EDITOR=vim
export EDITOR=vim

# GNU coreutils (ls, cat, etc.)
export PATH="/opt/homebrew/opt/coreutils/libexec/gnubin:$PATH"
# GNU findutils (find, xargs, etc.)
export PATH="/opt/homebrew/opt/findutils/libexec/gnubin:$PATH"

export XDG_CONFIG_HOME="$HOME/.config"
export K9S_CONFIG_DIR="$XDG_CONFIG_HOME/k9s"

# ============================================================================
# ALIASES
# ============================================================================

alias please="sudo"

# Prefer GNU tools over BSD ones
alias sed="gsed"
alias awk="gawk"

# Git aliases
alias g="generate"
alias ga="git add ."
alias gb="git branch -v"
alias gc="git commit"
alias gca="git commit -av"
alias gcl="git clone"
alias gco="git checkout -b"
alias gd="nvim +DiffviewOpen"
alias gf="git fetch --prune --all"
alias gl="git pull"
alias gma="git merge --abort"
alias gmc="git merge --continue"
alias gp="git push"
alias gpf="git push origin --force-with-lease"
alias gpom="git pull origin main"
alias gpo="git push origin --set-upstream HEAD"
alias gpr="gh pr create"
alias gpum="git pull upstream master"
alias gr="git remote"
alias gra="git remote add"
alias grao="git remote add origin"
alias grau="git remote add upstream"
alias grv="git remote -v"
alias gs="git status"
alias gst="git status"

# File listing aliases
alias l="lsd --group-dirs first -A"
alias ld="lazydocker"
alias lg="lazygit"
alias ll="lsd --group-dirs first -Al"
alias lt="lsd --group-dirs last -A --tree"

# Session management
alias s="sesh_start"
alias s.="sesh connect ."

# ============================================================================
# LAZY LOADING FUNCTIONS
# ============================================================================

# Lazy load nvm (only when needed)
_lazy_load_nvm() {
  unset -f nvm node npm npx
  export NVM_DIR="$HOME/.config/nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
}

# Create nvm wrapper functions
nvm() { _lazy_load_nvm && nvm "$@" }
node() { _lazy_load_nvm && node "$@" }
npm() { _lazy_load_nvm && npm "$@" }
npx() { _lazy_load_nvm && npx "$@" }

# Lazy load uv (only when needed)
_lazy_load_uv() {
  if command -v uv &> /dev/null; then
    unset -f _lazy_load_uv
    eval "$(uv generate-shell-completion zsh)"
    export PATH="$HOME/.local/bin:$PATH"
  fi
}

# Initialize uv lazily
if command -v uv &> /dev/null; then
  uv() { _lazy_load_uv && uv "$@" }
fi

# ============================================================================
# FAST INITIALIZATION
# ============================================================================

# Initialize zoxide (fast)
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

eval "$(starship init zsh)"