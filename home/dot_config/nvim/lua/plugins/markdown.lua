-- In-buffer markdown rendering: headings, code blocks, tables, checkboxes and
-- links are drawn as concealed virtual text while the cursor is elsewhere, and
-- fall back to raw source on the line being edited.
require("render-markdown").setup({
	completions = { blink = { enabled = true } },
	-- mini.icons is already mocked as nvim-web-devicons in plugins/mini.lua
	file_types = { "markdown" },
})

vim.keymap.set("n", "<leader>M", "<cmd>RenderMarkdown toggle<cr>", { desc = "Toggle markdown render" })
