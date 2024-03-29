-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- colors
vim.opt.termguicolors = true

-- leader
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- clipboard
vim.opt.clipboard = ""
--vim.opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- default position
vim.opt.scrolloff = 10

-- ex line
vim.o.ls = 0
vim.o.ch = 0

-- search
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.ignorecase = true -- ignore case when searching
vim.opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- gutter
vim.opt.number = true -- shows absolute line number on cursor line (when relative number is on)
vim.opt.relativenumber = true -- show relative line numbers
vim.opt.numberwidth = 4

-- indent
vim.opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2 -- 2 spaces for indent width
vim.opt.expandtab = true -- expand tab to spaces
vim.opt.smartindent = true -- copy indent from current line when starting new one
vim.opt.autoindent = true
vim.opt.showtabline = 0
vim.opt.showmatch = true

-- backup
vim.opt.backup = false
vim.opt.writebackup = false
vim.opt.swapfile = false -- turn off swapfile
vim.opt.undodir = os.getenv("HOME") .. "/.local/state/nvim/undo"
vim.opt.undofile = true

-- spelling
vim.opt.spell = false
vim.opt.spelllang = { "en_us" }

-- misc
--vim.opt.guicursor = ""
vim.opt.isfname:append("@-@")
vim.opt.signcolumn = "yes"
vim.opt.updatetime = 50
vim.opt.hidden = true -- allow hidden buffer
vim.opt.showmode = false -- disable vim showmode such as --INSERT--
vim.opt.errorbells = false
vim.opt.fileencoding = "utf-8"
vim.opt.colorcolumn = "100"

-- wrapping
vim.opt.wrap = false
vim.opt.linebreak = true

-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3
-- Default splitting will cause your main splits to jump when opening an edgebar.
-- To prevent this, set `splitkeep` to either `screen` or `topline`.
vim.opt.splitkeep = "screen"
vim.opt.splitright = true -- split vertical window to the right
vim.opt.splitbelow = true -- split horizontal window to the bottom

-- backspace
vim.opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- cursor line
vim.opt.cursorline = false -- highlight the current cursor line

-- use mouse
vim.opt.mouse = "a"

-- title
vim.opt.title = true
vim.opt.titlestring = "Neovim - %t"

-- vim.opt.nrformats:append("alpha") -- increment letters
vim.opt.shortmess:append("IsF")
-- vim.o.shortmess = "filnxstToOFS"
