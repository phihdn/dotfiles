# =========================================================
# Aliases
# =========================================================

alias please="sudo"
alias pls="sudo !!" # Run the last command with sudo

# Prefer GNU tools over BSD ones
alias sed="gsed"
alias awk="gawk"

# =========================================================
# Listing — lsd (primary) and eza (added from radley's config)
# =========================================================

alias l="lsd --group-dirs first -A"
alias ll="lsd --group-dirs first -Al"
alias lt="lsd --group-dirs last -A --tree"

alias ls='eza --icons'
alias la='eza -lah --icons --git'
alias tree='eza --tree --icons'
compdef eza=ls 2>/dev/null

# =========================================================
# Core utilities (from radley's config)
# =========================================================

alias grep='rg --color=auto'
alias diff='diff --color=auto'
alias df='df -h'
alias vim='nvim'
alias -- -='cd -'  # `-- ` stops - being read as a flag; `cd -` jumps to previous dir

# =========================================================
# TUIs
# =========================================================

alias ld="lazydocker"
alias lg="lazygit"

# =========================================================
# Session management (sesh)
# =========================================================

alias s="sesh_start"
alias s.="sesh connect ."

# =========================================================
# Claude Code — multiple accounts
# =========================================================
# Each account uses its own CLAUDE_CONFIG_DIR so logins, history, projects, and
# sessions stay isolated. Shared config (skills, agents, commands, settings,
# hooks, ...) is symlinked from ~/.claude into each dir. Run `/login` once per
# alias to sign in with the matching account.
alias claude-work="CLAUDE_CONFIG_DIR=\"\$HOME/.claude-work\" claude"
alias claude-personal="CLAUDE_CONFIG_DIR=\"\$HOME/.claude-personal\" claude"

# =========================================================
# Git
# =========================================================

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

# Pretty git logs (from radley's config)
alias glog='PAGER="less -F -X" git log'
alias gadog='PAGER="less -F -X" git log --all --decorate --oneline --graph'

# =========================================================
# Kubernetes
# =========================================================

alias k="kubectl"
alias kc="kubectl config current-context"
alias kctx="kubectl config use-context"
alias kns="kubectl config set-context --current --namespace"
alias kp="kubectl port-forward"
alias kpf="kubectl port-forward service"

# =========================================================
# Functions
# =========================================================

# lf: change to the directory chosen inside lf on quit (from radley's config)
lf() {
  local tmp dir
  tmp="$(mktemp)"
  command lf -last-dir-path="$tmp" "$@"
  if [ -f "$tmp" ]; then
    dir="$(cat "$tmp")"
    rm -f "$tmp"
    [ -d "$dir" ] && [ "$dir" != "$(pwd)" ] && cd "$dir"
  fi
}

# =========================================================
# AWS CLI
# =========================================================

alias aws-config="aws configure sso --profile $1" # Configure AWS SSO for a profile
