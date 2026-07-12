-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- LazyVim defaults to clipboard=unnamedplus, which syncs every register write
-- (including d/x/c deletes) to the system clipboard. Keep registers internal;
-- the TextYankPost autocmd in autocmds.lua copies only real yanks to it.
vim.opt.clipboard = ""
