local options = {
    -- line numbers
    relativenumber = true, -- set relative numbered lines
    number = true, -- set numbered lines

    -- tabs & indentation
    tabstop = 4, -- insert 4 spaces for a tab
    shiftwidth = 4, -- the number of spaces inserted for each indentation
    expandtab = true, -- convert tabs to spaces
    autoindent = true,

    -- line wrapping
    wrap = false, -- display lines as one long line

    -- search settings
    ignorecase = true, -- ignore case in search patterns
    smartcase = true, -- smart case

    -- cursor line
    cursorline = true, -- highlight the current line

    -- appearance
    termguicolors = true, -- set term gui colors (most terminals support this)
    background = "dark",
    signcolumn = "yes", -- always show the sign column, otherwise it would shift the text each time

    -- backspace
    backspace = "indent,eol,start",

    -- clipboard
    clipboard = "unnamedplus", -- allows neovim to access the system clipboard

    -- split windows
    splitbelow = true, -- force all horizontal splits to go below current window
    splitright = true, -- force all vertical splits to go to the right of current window

    backup = false, -- creates a backup file
    cmdheight = 1, -- more space in the neovim command line for displaying messages
    completeopt = { "menuone", "noselect" }, -- mostly just for cmp
    conceallevel = 0, -- so that `` is visible in markdown files
    fileencoding = "utf-8", -- the encoding written to a file
    hlsearch = true, -- highlight all matches on previous search pattern
    mouse = "a", -- allow the mouse to be used in neovim
    pumheight = 10, -- pop up menu height
    showmode = false, -- we don't need to see things like -- INSERT -- anymore
    showtabline = 2, -- always show tabs
    smartindent = true, -- make indenting smarter again
    swapfile = false, -- creates a swapfile
    timeoutlen = 300, -- time to wait for a mapped sequence to complete (in milliseconds)
    undofile = true, -- enable persistent undo
    updatetime = 300, -- faster completion (4000ms default)
    writebackup = false, -- if a file is being edited by another program (or was written to file while editing with another program), it is not allowed to be edited
    numberwidth = 4, -- set number column width to 4 {default 4}

    linebreak = true, -- companion to wrap, don't split words
    scrolloff = 8, -- minimal number of screen lines to keep above and below the cursor
    sidescrolloff = 8, -- minimal number of screen columns either side of cursor if wrap is `false`
    guifont = "monospace:h17", -- the font used in graphical neovim applications
    whichwrap = "bs<>[]hl", -- which "horizontal" keys are allowed to travel to prev/next line
}

for k, v in pairs(options) do
    vim.opt[k] = v
end

local opt = vim.opt -- for conciseness
-- opt.clipboard:append("unnamedplus")
-- opt.shortmess = "ilmnrx"                        -- flags to shorten vim messages, see :help 'shortmess'
opt.shortmess:append("c") -- don't give |ins-completion-menu| messages
opt.iskeyword:append("-") -- hyphenated words recognized by searches
opt.formatoptions:remove({ "c", "r", "o" }) -- don't insert the current comment leader automatically for auto-wrapping comments using 'textwidth', hitting <Enter> in insert mode, or hitting 'o' or 'O' in normal mode.
opt.runtimepath:remove("/usr/share/vim/vimfiles") -- separate vim plugins from neovim in case vim still in use
