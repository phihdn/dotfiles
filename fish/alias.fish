# aliases
#alias ls="ls -p -G"
#alias la="ls -A"
#alias ll="ls -l"
#alias lla="ll -A"
alias g "git"
if type -q exa
  alias ls "exa --icons --group-directories-first"
  alias ll "exa --icons --group-directories-first -l"
end
alias lla "ll -a"
alias grep "grep --color"
command -qv nvim && alias vim="nvim"