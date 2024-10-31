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

# -U or --universal Sets a universal variable. The variable will be immediately available to all the user’s fish instances on the machine, and will be persist across restarts of the shell.
# -f or --function Sets a variable scoped to the executing function. It is erased when the function ends.
# -l or --local Sets a locally-scoped variable in this block. It is erased when the block ends. Outside of a block, this is the same as --function.
# -g or --global Sets a globally-scoped variable. Global variables are available to all functions running in the same shell. They can be modified or erased.

# RUN fisher update to install plugins
# then run `fish_config theme save "Catppuccin Mocha"`

#echo "config loading..."
# https://starship.rs/
function starship_transient_prompt_func
    echo "$(starship module time) $(starship module character)"
end
function starship_transient_rprompt_func
    starship module status
end
starship init fish | source
enable_transience

# 'ajeetdsouza/zoxide'
zoxide init fish | source

function safe_source
    # func(safe_source) 'only source if file exists'
    if test -r $argv[1]
        source $argv[1]
    end
end

safe_source $HOME/.env.sh

#set -gx TERM screen-256color

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

# https://github.com/Jomik/fish-gruvbox
if status --is-interactive
    theme_gruvbox dark medium
end

# https://github.com/catppuccin/fzf
#set -Ux FZF_DEFAULT_OPTS "\
#--color=bg+:#313244,bg:#1e1e2e,spinner:#f5e0dc,hl:#f38ba8 \
#--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
#--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
#--color=selected-bg:#45475a \
#--multi"

# catppuccin transparent
#set -Ux FZF_DEFAULT_OPTS "\
#--color=bg+:#313244,spinner:#f5e0dc,hl:#f38ba8 \
#--color=fg:#cdd6f4,header:#f38ba8,info:#cba6f7,pointer:#f5e0dc \
#--color=marker:#b4befe,fg+:#cdd6f4,prompt:#cba6f7,hl+:#f38ba8 \
#--color=selected-bg:#45475a \
#--multi"

# gruvbox
set -Ux FZF_DEFAULT_OPTS "\
--color=bg+:#292929,bg:#292929,spinner:#ea6962,hl:#ea6962 \
--color=fg:#ebdbb2,header:#ea6962,info:#d3869b,pointer:#ea6962 \
--color=marker:#ea6962,fg+:#ebdbb2,prompt:#d3869b,hl+:#ea6962"


#echo "config loaded"

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/phihdn/Downloads/google-cloud-sdk/path.fish.inc' ]
    . '/Users/phihdn/Downloads/google-cloud-sdk/path.fish.inc'
end
