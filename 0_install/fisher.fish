#!/usr/bin/env fish

function info
	echo [(set_color --bold) ' .. ' (set_color normal)] $argv
end

function user
	echo [(set_color --bold) ' ?? ' (set_color normal)] $argv
end

function success
	echo [(set_color --bold green) ' OK ' (set_color normal)] $argv
end

function abort
	echo [(set_color --bold yellow) ABRT (set_color normal)] $argv
	exit 1
end

curl -sL git.io/fisher | source && fisher install jorgebucaran/fisher
	and success 'fisher'
	or abort 'fisher'

fisher update
	and success 'plugins'
	or abort 'plugins'

yes | fish_config theme save "Catppuccin Macchiato"
	and success 'colorscheme'
	or abort 'colorscheme'