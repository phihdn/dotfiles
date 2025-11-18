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
