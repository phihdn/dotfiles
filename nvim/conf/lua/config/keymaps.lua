-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local opts = { noremap = true, silent = true }
local map = vim.keymap.set

-- Exit on jj and jk
map("i", "jj", "<ESC>", opts)
map("i", "jk", "<ESC>", opts)

-- paste over currently selected text without yanking it
map("v", "p", '"_dp') -- p puts text after the cursor
map("v", "P", '"_dP') -- P puts text before the cursor

map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Copy to clipboard" })
map("n", "<leader>Y", [["+Y]], { desc = "Copy line to clipboard" })

-- delete single character without copying into register
map("n", "x", '"_x', opts)
