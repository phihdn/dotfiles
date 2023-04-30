#!/usr/bin/env fish
#
# ███████╗██╗███████╗██╗  ██╗
# ██╔════╝██║██╔════╝██║  ██║
# █████╗  ██║███████╗███████║
# ██╔══╝  ██║╚════██║██╔══██║
# ██║     ██║███████║██║  ██║
# ╚═╝     ╚═╝╚══════╝╚═╝  ╚═╝
# A smart and user-friendly command line
# https://fishshell.com
# cSpell:words ajeetdsouza cppflags ldflags pkgconfig pnpm nvim Nord gopath nvimpager ripgreprc ripgrep zoxide joshmedeski sharkdp neovim lucc

#echo "config loading..."
starship init fish | source # https://starship.rs/
zoxide init fish | source # 'ajeetdsouza/zoxide'

function safe_source
  # func(safe_source) 'only source if file exists'
  if test -r $argv[1]
    source $argv[1]
  end
end

safe_source $HOME/.env.sh

set -gx TERM xterm-256color

#set -Ux BAT_THEME Nord # 'sharkdp/bat' cat clone
set -Ux EDITOR nvim # 'neovim/neovim' text editor
set -Ux VISUAL nvim
set -Ux fish_greeting # disable fish greeting
set -Ux LANG en_US.UTF-8
set -Ux LC_ALL en_US.UTF-8
set -U FZF_DEFAULT_COMMAND "fd -H -E '.git'"
#set -Ux NODE_PATH "~/.nvm/versions/node/v16.19.0/bin/node" # 'nvm-sh/nvm'
#set -gx RIPGREP_CONFIG_PATH "$HOME/.config/rg/ripgreprc"


# ordered by priority - bottom up
fish_add_path $HOME/.local/bin
fish_add_path $HOME/.config/tmux/plugins/t-smart-tmux-session-manager/bin
fish_add_path $HOME/.config/bin # my custom scripts

# NodeJS
#set -gx PATH node_modules/.bin $PATH

# Go
#set -g GOPATH $HOME/go
#set -g GOROOT /usr/local/go
#set -gx PATH $GOPATH/bin $PATH
#set -gx PATH $GOROOT/bin $PATH
set -Ux GOPATH (go env GOPATH) # https://go.dev
set -Ux GOROOT (go env GOROOT)
fish_add_path $GOPATH/bin
fish_add_path $GOROOT/bin

# NVM
#function __check_rvm --on-variable PWD --description 'Do nvm stuff'
#  status --is-command-substitution; and return
#
#  if test -f .nvmrc; and test -r .nvmrc;
#    nvm use
#  else
#  end
#end

switch (uname)
  case Darwin
    safe_source $DOTFILES/fish/config-osx.fish
  case Linux
    safe_source $DOTFILES/fish/config-linux.fish
  case '*'
    safe_source $DOTFILES/fish/config-windows.fish
end

safe_source $DOTFILES/fish/alias.fish

# https://github.com/catppuccin/fzf
set -Ux FZF_DEFAULT_OPTS "\
--color=bg+:#363a4f,bg:#24273a,spinner:#f4dbd6,hl:#ed8796 \
--color=fg:#cad3f5,header:#ed8796,info:#c6a0f6,pointer:#f4dbd6 \
--color=marker:#f4dbd6,fg+:#cad3f5,prompt:#c6a0f6,hl+:#ed8796"

#echo "config loaded"
