-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- With clipboard sync disabled (options.lua), plain p pastes the internal
-- unnamed register (last yank OR delete). Paste from the OS clipboard:
vim.keymap.set({ "n", "x" }, "<leader>p", '"+p', { desc = "Paste from clipboard" })
vim.keymap.set({ "n", "x" }, "<leader>P", '"+P', { desc = "Paste from clipboard before cursor" })

-- Carried over from the pre-LazyVim config (Primeagen-inspired) -------------

-- Keep the cursor centered when jumping half-pages and between search results.
-- n/N extend LazyVim's direction-consistent versions (n always searches
-- forward regardless of / vs ?) with the centering.
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Half-page down (centered)" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Half-page up (centered)" })
vim.keymap.set("n", "n", "'Nn'[v:searchforward].'zzzv'", { expr = true, desc = "Next Search Result" })
vim.keymap.set("n", "N", "'nN'[v:searchforward].'zzzv'", { expr = true, desc = "Prev Search Result" })
vim.keymap.set("n", "*", "*zzzv", { desc = "Search word under cursor (centered)" })
vim.keymap.set("n", "#", "#zzzv", { desc = "Search word backward (centered)" })
vim.keymap.set("n", "g*", "g*zzzv", { desc = "Search word under cursor, partial (centered)" })
vim.keymap.set("n", "g#", "g#zzzv", { desc = "Search word backward, partial (centered)" })

-- Move the visual selection up/down with J/K (LazyVim also offers <A-j>/<A-k>)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Join lines without the cursor jumping to the join point
vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines (keep cursor)" })

-- x deletes a character without clobbering the unnamed register,
-- so yank-then-x-then-p still pastes the yank
vim.keymap.set("n", "x", '"_x', { desc = "Delete char (keep register)" })

-- X splits the line at the cursor (inverse of J), trimming surrounding spaces
vim.keymap.set("n", "X", ":keeppatterns substitute/\\s*\\%#\\s*/\\r/e <bar> normal! ==^<cr>", { silent = true, desc = "Split line at cursor" })

-- Exit insert mode with jj / jk
vim.keymap.set("i", "jj", "<ESC>", { desc = "Exit insert mode" })
vim.keymap.set("i", "jk", "<ESC>", { desc = "Exit insert mode" })

-- Line diagnostics in a float (LazyVim equivalent: <leader>cd)
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Line Diagnostics (float)" })

-- Copy the file path to the clipboard
-- (was <leader>fp pre-migration; that's the Projects picker in LazyVim)
vim.keymap.set("n", "<leader>fy", function()
  local path = vim.fn.expand("%:~")
  vim.fn.setreg("+", path)
  vim.notify("Copied: " .. path)
end, { desc = "Copy file path to clipboard" })
