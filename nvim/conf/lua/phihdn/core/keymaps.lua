local keymap = vim.keymap -- for conciseness

-- use jj to exit insert mode
keymap.set("i", "jj", "<ESC>", { desc = "Exit insert mode with jj" })

-- clear search highlights
keymap.set("n", "<leader><leader>", ":noh<CR>", { desc = "Clear search highlights" })

-- delete single character without copying into register
-- keymap.set("n", "x", '"_x')

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab

-- delete single character without copying into register
-- keymap.set("n", "x", '"_x')
keymap.set("x", "<leader>p", [["_dP]], { desc = "Paste over" })
keymap.set({ "n", "v" }, "<leader>y", [["+y]], { desc = "Copy to clipboard" })
keymap.set("n", "<leader>Y", [["+Y]], { desc = "Copy" })
keymap.set({ "n", "v" }, "<leader>d", [["_d]], { desc = "Cut" })

-- move lines down/up
keymap.set("v", "J", ":m '>+1<CR>gv=gv")
keymap.set("v", "K", ":m '<-2<CR>gv=gv")

--keymap.set("n", "J", "mzJ`z")
keymap.set("n", "<C-d>", "<C-d>zz")
keymap.set("n", "<C-u>", "<C-u>zz")
keymap.set("n", "n", "nzzzv")
keymap.set("n", "N", "Nzzzv")

-- Stay in indent mode
keymap.set("v", "<", "<gv")
keymap.set("v", ">", ">gv")

-- Navigate buffers
keymap.set("n", "<S-l>", ":bnext<CR>")
keymap.set("n", "<S-h>", ":bprevious<CR>")

-- buffer
keymap.set("n", "<leader>bb", "<cmd>Telescope buffers<cr>", { desc = "Telescope" })
keymap.set("n", "<leader>bj", "<cmd>bn<cr>", { desc = "Next" })
keymap.set("n", "<leader>bk", "<cmd>bp<cr>", { desc = "Previous" })
keymap.set("n", "<leader>bn", "<cmd>bn<cr>", { desc = "Next" })
keymap.set("n", "<leader>bp", "<cmd>bp<cr>", { desc = "Previous" })
keymap.set("n", "<leader>bsd", "<cmd>%bd|e#|bd#<cr>|'<cr>", { desc = "Delete surrounding" })
