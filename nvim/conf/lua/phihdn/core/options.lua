-- leader
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- colors
vim.opt.termguicolors = true -- set term gui colors (most terminals support this)

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
--vim.opt.clipboard = 'unnamedplus'
--vim.opt.clipboard:append("unnamedplus") -- use system clipboard as default register
vim.opt.clipboard = ""

-- default position
vim.opt.scrolloff = 10 -- start scrolling when the cursor is 10 lines away from the edge
vim.opt.sidescrolloff = 10 -- start scrolling when the cursor is 10 lines away from the side

-- ex line
vim.o.ls = 0
vim.o.ch = 0

-- search
vim.opt.hlsearch = true -- highlight all matches on previous search pattern
vim.opt.incsearch = true -- make search act like search in modern browsers
vim.opt.ignorecase = true -- ignore case when searching
vim.opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- gutter
vim.opt.number = true -- shows absolute line number on cursor line (when relative number is on)
vim.opt.relativenumber = true -- show relative line numbers
vim.opt.numberwidth = 4 -- set the width of line number

-- indent
vim.opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
vim.opt.softtabstop = 2
vim.opt.shiftwidth = 2 -- the number of spaces inserted for each indentation
vim.opt.expandtab = true -- convert tabs to spaces
vim.opt.smartindent = true -- copy indent from current line when starting new one
vim.opt.autoindent = true
vim.opt.showtabline = 0 -- always show tabs
vim.opt.showmatch = true

-- backup
vim.opt.backup = false
vim.opt.writebackup = false -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
vim.opt.swapfile = false -- turn off swapfile
vim.opt.undodir = os.getenv("HOME") .. "/.local/state/nvim/undo"
vim.opt.undofile = true -- enable persistent undo

-- spelling
vim.opt.spell = false
vim.opt.spelllang = { "en_us" }

-- misc
--vim.opt.guicursor = "" -- set the cursor to be a vertical bar
vim.opt.isfname:append("@-@")
vim.opt.signcolumn = "yes" -- always show the sign column, otherwise it would shift the text each time
vim.opt.updatetime = 100 -- faster completion (4000ms default)
vim.opt.hidden = true -- allow hidden buffer
-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false
vim.opt.errorbells = false
vim.opt.fileencoding = "utf-8" -- the encoding written to a file
vim.opt.colorcolumn = "100"
vim.opt.cmdheight = 1 -- more space in the neovim command line for displaying messages
vim.opt.pumheight = 10 -- pop up menu height
vim.opt.completeopt = { "menuone", "noselect" } -- mostly just for cmp
vim.opt.conceallevel = 0 -- so that `` is visible in markdown files
vim.opt.timeoutlen = 1000 -- time to wait for a mapped sequence to complete (in milliseconds)
vim.opt.showcmd = false -- Don't show the command in the last line
vim.opt.ruler = false -- Don't show the ruler
vim.opt.confirm = true -- confirm to save changes before exiting modified buffer
vim.opt.fillchars = { eob = " " }               -- change the character at the end of buffer

-- wrapping
vim.opt.wrap = false -- display lines as one long line
vim.opt.linebreak = true
vim.opt.breakindent = true  -- wrap lines with indent

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

-- Preview substitutions live, as you type!
vim.opt.inccommand = 'split'

-- views can only be fully collapsed with the global statusline
vim.opt.laststatus = 3
-- Default splitting will cause your main splits to jump when opening an edgebar.
-- To prevent this, set `splitkeep` to either `screen` or `topline`.
vim.opt.splitkeep = "screen"
vim.opt.splitright = true -- split vertical window to the right
vim.opt.splitbelow = true -- split horizontal window to the bottom

-- backspace
vim.opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- title
vim.opt.title = true -- set the title of window to the value of the titlestring
vim.opt.titlestring = "Neovim - %t"

-- vim.opt.nrformats:append("alpha") -- increment letters
vim.opt.shortmess:append("IsF")
-- vim.o.shortmess = "filnxstToOFS"