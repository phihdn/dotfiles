-- Core keymaps (no plugins). Plugin keymaps live next to their plugin in
-- lua/phihdn/plugins/; which-key (<leader>) and <leader>fk list them all.
-- Leader prefixes: b buffer · c code · e explorer · f find · g git
--                  s split · u ui toggles · x diagnostics lists · y/p clipboard
local map = vim.keymap.set

-- Editing --------------------------------------------------------------------
map("i", "jk", "<Esc>", { desc = "Exit insert mode" })
map("n", "x", '"_x', { desc = "Delete char (keep registers)" })
map("x", "p", "P", { desc = "Paste over selection (keep register)" })
map("n", "J", "mzJ`z", { desc = "Join lines (keep cursor)" })
-- shadows builtin X (delete char before cursor)
map(
  "n",
  "X",
  ":keeppatterns substitute/\\s*\\%#\\s*/\\r/e <bar> normal! ==^<CR>",
  { silent = true, desc = "Split line at cursor" }
)
map("x", "J", ":m '>+1<CR>gv=gv", { silent = true, desc = "Move selection down" })
map("x", "K", ":m '<-2<CR>gv=gv", { silent = true, desc = "Move selection up" })
map("x", "<", "<gv", { desc = "Indent left (keep selection)" })
map("x", ">", ">gv", { desc = "Indent right (keep selection)" })

-- Motion ---------------------------------------------------------------------
-- move by screen line when wrapping, but keep real-line motion for counts (5j)
map("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, desc = "Down (screen line)" })
map("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, desc = "Up (screen line)" })
-- keep the cursor centered (and open folds) on big jumps and search hits
map("n", "<C-d>", "<C-d>zz", { desc = "Half page down (centered)" })
map("n", "<C-u>", "<C-u>zz", { desc = "Half page up (centered)" })
for _, key in ipairs({ "n", "N", "*", "#", "g*", "g#" }) do
  map("n", key, key .. "zzzv", { desc = "Search " .. key .. " (centered)" })
end
map("n", "<Esc>", "<cmd>nohlsearch<CR><Esc>", { desc = "Clear search highlight" })

-- Clipboard: <leader>y / <leader>p mirror y / p against the system clipboard;
-- plain y / p stay on nvim's registers ('clipboard' is empty on purpose)
map({ "n", "x" }, "<leader>y", '"+y', { desc = "Yank to clipboard" })
map("n", "<leader>Y", '"+Y', { desc = "Yank line to clipboard" })
map({ "n", "x" }, "<leader>p", '"+p', { desc = "Paste from clipboard" })
map("n", "<leader>P", '"+P', { desc = "Paste from clipboard (before)" })
map("n", "<leader>yp", function()
  local path = vim.fn.expand("%:~")
  vim.fn.setreg("+", path)
  vim.notify("Copied " .. path)
end, { desc = "Yank file path to clipboard" })
map("n", "<leader>ym", function()
  vim.fn.setreg("+", vim.fn.execute("messages"))
  vim.notify("Copied :messages")
end, { desc = "Yank :messages to clipboard" })

-- Buffers & splits -----------------------------------------------------------
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Next buffer" })
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>bd", "<cmd>bdelete<CR>", { desc = "Delete buffer" })
map("n", "<leader>sv", "<C-w>v", { desc = "Split vertically" })
map("n", "<leader>sh", "<C-w>s", { desc = "Split horizontally" })
map("n", "<leader>se", "<C-w>=", { desc = "Equalize splits" })
map("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close split" })

-- Diagnostics (nvim's defaults add [d ]d to jump and <C-w>d for this float)
map("n", "gl", vim.diagnostic.open_float, { desc = "Line diagnostics" })

-- UI toggles -----------------------------------------------------------------
local toggle = function(lhs, option, desc)
  map("n", lhs, function()
    vim.wo[option] = not vim.wo[option]
    vim.notify(("%s %s"):format(option, vim.wo[option] and "on" or "off"))
  end, { desc = desc })
end
toggle("<leader>uw", "wrap", "Toggle wrap")
toggle("<leader>us", "spell", "Toggle spell")
map("n", "<leader>ud", function()
  vim.diagnostic.enable(not vim.diagnostic.is_enabled())
end, { desc = "Toggle diagnostics" })
