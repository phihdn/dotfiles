-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.opt.scrolloff = 10 -- start scrolling when the cursor is 10 lines away from the edge
vim.opt.sidescrolloff = 10 -- start scrolling when the cursor is 10 lines away from the side

-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

vim.opt.clipboard = "" -- don't use system clipboard
