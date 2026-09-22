-- enhanced, a and i keybinds
require("mini.ai").setup()

-- auto pairs
require("mini.pairs").setup()

-- surround on the gs prefix, matching the personal scheme:
-- gsa" (add), gsd" (delete), gsr"' (replace " with ')
require("mini.surround").setup({
	mappings = {
		add = "gsa",
		delete = "gsd",
		find = "gsf",
		find_left = "gsF",
		highlight = "gsh",
		replace = "gsr",
		update_n_lines = "gsn",
	},
})

-- icons, replace nvim_web_devicons
require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()

-- better jump capabilities
require("mini.jump").setup()

-- file explorer: popup Miller columns with preview; file ops are edit-as-text
-- like oil (rename/move/delete lines, then = to sync)
local MiniFiles = require("mini.files")
MiniFiles.setup({
	mappings = {
		go_in = "<CR>",
		go_in_plus = "L",
		go_out = "-",
		go_out_plus = "H",
	},
	windows = {
		preview = true,
		width_preview = 40,
	},
})

-- <CR> on a file opens it AND closes the explorer; on a directory it just
-- navigates in (go_in's close_on_file only acts on files)
vim.api.nvim_create_autocmd("User", {
	pattern = "MiniFilesBufferCreate",
	callback = function(args)
		vim.keymap.set("n", "<CR>", function()
			MiniFiles.go_in({ close_on_file = true })
		end, { buffer = args.data.buf_id, desc = "Go in (close on file)" })
		vim.keymap.set("n", "<Esc>", MiniFiles.close, { buffer = args.data.buf_id, desc = "Close file explorer" })
	end,
})

vim.keymap.set("n", "<leader>ee", function()
	if not MiniFiles.close() then
		MiniFiles.open()
	end
end, { desc = "Toggle file explorer" })
vim.keymap.set("n", "<leader>ef", function()
	MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
	MiniFiles.reveal_cwd()
end, { desc = "Explore current file's directory" })
