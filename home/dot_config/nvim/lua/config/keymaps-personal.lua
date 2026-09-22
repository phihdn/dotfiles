-- Personal keymap scheme restored from the pre-smnatale config
-- (branch 20260915-nvim-pre-smnatale, lua/phihdn/*).
--
-- Loaded last, after plugins/init.lua, so it can both override upstream
-- mappings and reach plugin modules. Where the old scheme used a plugin this
-- config no longer ships, the binding points at the current equivalent:
--   fzf-lua  -> telescope        trouble   -> telescope + quicker
--   diffview -> zdiff            mini.files stays mini.files
-- Plugin requires stay inside the callbacks so nothing is force-loaded here.

local opts = { noremap = true, silent = true }

-- Drop upstream mappings whose lhs the old scheme needs as a group prefix, or
-- whose key the old scheme gives to something else. del is wrapped because a
-- missing mapping is not an error worth failing startup over.
local function unmap(mode, lhs)
	pcall(vim.keymap.del, mode, lhs)
end

unmap("n", "<leader>f") -- format buffer -> <leader>f is the find group, format is <leader>cf
unmap("n", "<leader>e") -- Oil -> <leader>e is the explorer group, Oil is \ and -
unmap("n", "<leader>sf") -- <leader>s becomes the split group; the search maps
unmap("n", "<leader>sF") -- all move under <leader>f
unmap("n", "<leader>sg")
unmap("n", "<leader>su")
unmap("n", "<leader>sd")
unmap("n", "<leader>sh")
unmap("n", "<leader>sk")
unmap("n", "<S-k>") -- K goes back to LSP hover; page scroll is <C-u>/<C-d>
unmap("n", "<S-j>") -- J goes back to join-and-keep-cursor

--------------------------------------------------------------------------
-- Core editing
--------------------------------------------------------------------------

vim.keymap.set("n", "\\", "<cmd>Oil --float<CR>", { desc = "Open parent directory in Oil (float)" })
vim.keymap.set("n", "-", "<cmd>Oil<CR>", { desc = "Open parent directory" })
vim.keymap.set("n", "<leader>-", function()
	require("oil").toggle_float()
end, { desc = "Toggle Oil float" })

vim.keymap.set("n", "gl", function()
	vim.diagnostic.open_float()
end, { desc = "Open diagnostics in float" })

-- Keep cursor centered when scrolling
vim.keymap.set("n", "<C-d>", "<C-d>zz", opts)
vim.keymap.set("n", "<C-u>", "<C-u>zz", opts)

-- Move selected line / block of text in visual mode
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move lines down in visual selection" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move lines up in visual selection" })

vim.keymap.set("n", "J", "mzJ`z", { desc = "Join lines and keep cursor in the middle" })

-- Move by screen line when wrapping, but keep real-line motion for counts (5j)
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true })

-- Better indenting without reselecting
vim.keymap.set("v", "<", "<gv")
vim.keymap.set("v", ">", ">gv")

vim.keymap.set({ "n", "x" }, "<leader>y", [["+y]], { desc = "Copy to clipboard" })
vim.keymap.set("n", "<leader>Y", [["+Y]], { desc = "Copy line to clipboard" })
vim.keymap.set("n", "<leader>ym", function()
	vim.fn.setreg("+", vim.fn.execute("messages"))
	vim.notify("Messages copied to clipboard")
end, { desc = "Yank :messages to clipboard" })

-- Paste over selection without clobbering the unnamed register
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

-- Delete single character without copying into register
vim.keymap.set("n", "x", '"_x', opts)

-- Copy filepath to the clipboard
vim.keymap.set("n", "<leader>fp", function()
	local filePath = vim.fn.expand("%:~")
	vim.fn.setreg("+", filePath)
	print("File path copied to clipboard: " .. filePath)
end, { desc = "Copy file path to clipboard" })

--------------------------------------------------------------------------
-- Split management  <leader>s
--------------------------------------------------------------------------

vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" })
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" })
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" })

--------------------------------------------------------------------------
-- Find  <leader>f  (was fzf-lua, now telescope)
--------------------------------------------------------------------------

-- Old fzf-lua searched from the project directory; telescope needs that root
-- passed explicitly, so mirror the helper upstream uses in plugins/telescope.lua.
local function project_root()
	return vim.fs.root(0, { ".git" }) or vim.fs.root(vim.fn.getcwd(), { ".git" }) or vim.fn.getcwd()
end

local function pick(name, make_args)
	return function()
		local builtin = require("telescope.builtin")
		builtin[name](make_args and make_args() or {})
	end
end

vim.keymap.set("n", "<leader>ff", function()
	require("telescope").extensions.frecency.frecency({ cwd = project_root(), workspace = "CWD", hidden = true })
end, { desc = "[F]ind [F]iles in project directory" })
vim.keymap.set("n", "<leader>fg", pick("live_grep", function()
	return { cwd = project_root() }
end), { desc = "[F]ind by [G]repping in project directory" })
vim.keymap.set("n", "<leader>fn", pick("find_files", function()
	return { cwd = vim.fn.stdpath("config") }
end), { desc = "[F]ind in [N]eovim configuration" })
vim.keymap.set("n", "<leader>fh", pick("help_tags"), { desc = "[F]ind [H]elp" })
vim.keymap.set("n", "<leader>fk", pick("keymaps"), { desc = "[F]ind [K]eymaps" })
vim.keymap.set("n", "<leader>fb", pick("buffers"), { desc = "[F]ind [B]uffers" })
vim.keymap.set("n", "<leader>fz", pick("builtin"), { desc = "[F]ind telescope builtin pickers" })
vim.keymap.set("n", "<leader>fw", pick("grep_string", function()
	return { cwd = project_root() }
end), { desc = "[F]ind current [W]ord" })
vim.keymap.set("n", "<leader>fW", pick("grep_string", function()
	return { cwd = project_root(), search = vim.fn.expand("<cWORD>") }
end), { desc = "[F]ind current [W]ORD" })
vim.keymap.set("n", "<leader>fd", pick("diagnostics", function()
	return { bufnr = 0 }
end), { desc = "[F]ind buffer [D]iagnostics" })
vim.keymap.set("n", "<leader>fD", pick("diagnostics"), { desc = "[F]ind workspace [D]iagnostics" })
vim.keymap.set("n", "<leader>fr", pick("resume"), { desc = "[F]ind [R]esume" })
vim.keymap.set("n", "<leader>fo", pick("oldfiles"), { desc = "[F]ind [O]ld Files" })
vim.keymap.set("n", '<leader>f"', pick("registers"), { desc = '[F]ind ["]Registers' })

vim.keymap.set("n", "<leader>:", pick("command_history"), { desc = "Command History" })
vim.keymap.set("n", "<leader><leader>", pick("buffers"), { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>/", pick("current_buffer_fuzzy_find"), { desc = "[/] Live grep the current buffer" })

--------------------------------------------------------------------------
-- Code  <leader>c
--------------------------------------------------------------------------

vim.keymap.set({ "n", "v" }, "<leader>cf", function()
	require("conform").format({ lsp_fallback = true, async = true })
end, { desc = "[C]ode [F]ormat buffer" })

--------------------------------------------------------------------------
-- Git  <leader>g  (diffview -> zdiff, fzf-lua git pickers -> telescope)
--------------------------------------------------------------------------

vim.keymap.set("n", "<leader>gc", pick("git_commits"), { desc = "Search [g]it [c]ommits" })
vim.keymap.set("n", "<leader>gs", pick("git_status"), { desc = "Search [g]it [s]tatus" })
vim.keymap.set("n", "<leader>gv", function()
	require("zdiff").open()
end, { desc = "Diff working tree (zdiff)" })
vim.keymap.set("n", "<leader>gV", function()
	require("zdiff").open("main")
end, { desc = "Diff against main (zdiff)" })

--------------------------------------------------------------------------
-- Diagnostics  <leader>x  (was trouble)
--------------------------------------------------------------------------

vim.keymap.set("n", "<leader>xw", pick("diagnostics"), { desc = "Workspace diagnostics" })
vim.keymap.set("n", "<leader>xd", pick("diagnostics", function()
	return { bufnr = 0 }
end), { desc = "Document diagnostics" })
vim.keymap.set("n", "<leader>xq", function()
	require("quicker").toggle()
end, { desc = "Toggle quickfix list" })
vim.keymap.set("n", "<leader>xl", function()
	require("quicker").toggle({ loclist = true })
end, { desc = "Toggle location list" })

--------------------------------------------------------------------------
-- UI toggles  <leader>u
--------------------------------------------------------------------------

vim.keymap.set("n", "<leader>uB", "<cmd>Gitsigns toggle_current_line_blame<cr>", { desc = "Toggle inline git blame" })
