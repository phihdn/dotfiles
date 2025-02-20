local opts = { noremap = true, silent = true }

-- Keep cursor centered when scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)

-- Move selected line / block of text in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", opts)
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", opts)

-- Remap for dealing with visual line wraps
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- better indenting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set({ "n", "v", "x" }, "<leader>y", [["+y]], { desc = "Copy to clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Copy line to clipboard" })

-- paste over currently selected text without yanking it
vim.keymap.set("v", "p", [["_dp]]) -- p puts text after the cursor
vim.keymap.set("v", "P", [["_dP]]) -- P puts text before the cursor

-- Move line on the screen rather than by line in the file
vim.keymap.set("n", "j", "gj", opts)
vim.keymap.set("n", "k", "gk", opts)

-- Exit on jj and jk
vim.keymap.set("i", "jj", "<ESC>", opts)
vim.keymap.set("i", "jk", "<ESC>", opts)

-- Navigate buffers
vim.keymap.set("n", "<S-l>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", opts)

-- Panes resizing
vim.keymap.set("n", "+", ":vertical resize +5<CR>")
vim.keymap.set("n", "_", ":vertical resize -5<CR>")
vim.keymap.set("n", "=", ":resize +5<CR>")
vim.keymap.set("n", "-", ":resize -5<CR>")

vim.keymap.set("n", "n", "nzzv", opts)
vim.keymap.set("n", "N", "Nzzv", opts)
vim.keymap.set("n", "*", "*zzv", opts)
vim.keymap.set("n", "#", "#zzv", opts)
vim.keymap.set("n", "g*", "g*zz", opts)
vim.keymap.set("n", "g#", "g#zz", opts)

-- Split line with X: remove from the cursor til the end
vim.keymap.set("n", "X", ":keeppatterns substitute/\\s*\\%#\\s*/\\r/e <bar> normal! ==^<cr>", { silent = true })

vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", opts)

-- delete single character without copying into register
vim.keymap.set("n", "x", '"_x', opts)
