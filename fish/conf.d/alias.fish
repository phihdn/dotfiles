# aliases
#alias ls="ls -p -G"
#alias la="ls -A"
#alias ll="ls -l"
#alias lla="ll -A"
#if type -q eza
#    alias ls "eza --icons --group-directories-first"
#    alias ll "eza --icons --group-directories-first -l"
#end
alias lla "ll -a"
alias grep "grep --color"
command -qv nvim && alias vim nvim
alias s "source ~/.config/fish/config.fish"

# GIT ALIASES -----------------------------------------------------------------
alias gs "git status"

# https://github.com/joshmedeski/sesh
alias t "sesh connect"
