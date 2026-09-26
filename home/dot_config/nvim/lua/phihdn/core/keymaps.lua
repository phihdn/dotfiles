local opts = { noremap = true, silent = true }

vim.keymap.set("n", "\\", "<cmd>Oil --float<CR>", { desc = "Open Parent Directory in Oil" })
vim.keymap.set("n", "gl", function()
  vim.diagnostic.open_float()
end, { desc = "Open Diagnostics in Float" })

-- Keep cursor centered when scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)

-- Move selected line / block of text in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "moves lines down in visual selection" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "moves lines up in visual selection" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor in the middle" })

-- Move by screen line when wrapping, but keep real-line motion for counts (5j)
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- better indenting without reselecting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set({ "n", "x" }, "<leader>y", [["+y]], { desc = "Copy to clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Copy line to clipboard" })
vim.keymap.set("n", "<leader>ym", function()
  vim.fn.setreg("+", vim.fn.execute("messages"))
  vim.notify("Messages copied to clipboard")
end, { desc = "Yank :messages to clipboard" })

-- paste over selection without clobbering the unnamed register
-- (builtin visual P has done this natively since nvim 0.10)
vim.keymap.set("x", "p", "P")

-- Exit insert mode with jk
vim.keymap.set("i", "jk", "<ESC>", opts)

-- Navigate buffers
vim.keymap.set("n", "<S-l>", ":bnext<CR>", opts)
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", opts)
vim.keymap.set("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })

-- Center screen (and reopen folds) when jumping between matches
vim.keymap.set("n", "n", "nzzzv", opts)
vim.keymap.set("n", "N", "Nzzzv", opts)
vim.keymap.set("n", "*", "*zzzv", opts)
vim.keymap.set("n", "#", "#zzzv", opts)
vim.keymap.set("n", "g*", "g*zzzv", opts)
vim.keymap.set("n", "g#", "g#zzzv", opts)

-- Split line at cursor (shadows builtin X = delete char before cursor)
vim.keymap.set("n", "X", ":keeppatterns substitute/\\s*\\%#\\s*/\\r/e <bar> normal! ==^<cr>", { silent = true })

vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR><Esc>", opts)

-- delete single character without copying into register
vim.keymap.set("n", "x", '"_x', opts)

--split management
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

-- Copy filepath to the clipboard
vim.keymap.set("n", "<leader>fp", function()
  local filePath = vim.fn.expand("%:~")
  vim.fn.setreg("+", filePath)
  print("File path copied to clipboard: " .. filePath)
end, { desc = "Copy file path to clipboard" })
