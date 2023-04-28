if status is-interactive
    # Commands to run in interactive sessions can go here
end

function source_if_exists
    if test -r "$1"
        source "$1"
    end
end

set fish_greeting ""

set -gx TERM xterm-256color

# theme
set -g theme_color_scheme terminal-dark
set -g fish_prompt_pwd_dir_length 1
set -g theme_display_user yes
set -g theme_hide_hostname no
set -g theme_hostname always

# aliases
alias ls "ls -p -G"
alias la "ls -A"
alias ll "ls -l"
alias lla "ll -A"
alias g git
command -qv nvim && alias vim nvim

set -gx EDITOR nvim

set -gx PATH bin $PATH
set -gx PATH ~/bin $PATH
set -gx PATH ~/.local/bin $PATH

# NodeJS
#set -gx PATH node_modules/.bin $PATH

# Go
set -g GOPATH $HOME/go
set -g GOROOT /usr/local/go
set -gx PATH $GOPATH/bin $PATH
set -gx PATH $GOROOT/bin $PATH

# NVM
function __check_rvm --on-variable PWD --description 'Do nvm stuff'
  status --is-command-substitution; and return

  if test -f .nvmrc; and test -r .nvmrc;
    nvm use
  else
  end
end

switch (uname)
  case Darwin
    source_if_exists $DOTFILES/fish/config-osx.fish
  case Linux
    source_if_exists $DOTFILES/fish/config-linux.fish
  case '*'
    source_if_exists $DOTFILES/fish/config-windows.fish
end

starship init fish | source