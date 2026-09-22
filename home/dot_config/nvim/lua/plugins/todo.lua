-- Highlight and jump through TODO/FIX/HACK style comment tags.
local todo_comments = require("todo-comments")

todo_comments.setup({
	keywords = {
		FIX = {
			icon = " ", -- icon used for the sign, and in search results
			color = "error", -- can be a hex color, or a named color
			alt = { "FIXME", "BUG", "FIXIT", "ISSUE" }, -- other keywords mapping to FIX
		},
		TODO = { icon = " ", color = "info" },
		HACK = { icon = " ", color = "warning", alt = { "DON SKIP" } },
		WARN = { icon = " ", color = "warning", alt = { "WARNING", "XXX" } },
		PERF = { icon = " ", alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" } },
		NOTE = { icon = " ", color = "hint", alt = { "INFO", "READ", "COLORS" } },
		TEST = { icon = "⏲ ", color = "test", alt = { "TESTING", "PASSED", "FAILED" } },
	},
})

vim.keymap.set("n", "]t", function()
	todo_comments.jump_next()
end, { desc = "Next todo comment" })

vim.keymap.set("n", "[t", function()
	todo_comments.jump_prev()
end, { desc = "Previous todo comment" })

-- The old scheme listed todos in trouble; telescope is the equivalent here.
vim.keymap.set("n", "<leader>xt", "<cmd>TodoTelescope<cr>", { desc = "Search todo comments" })
