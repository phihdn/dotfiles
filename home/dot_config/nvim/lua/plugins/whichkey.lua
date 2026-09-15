-- Popup showing what keys are available after a prefix. Added while learning
-- this config's mappings; `<leader>sk` (Telescope keymaps) is the searchable
-- counterpart when you want to grep rather than browse.
require("which-key").setup({
	preset = "helix",
	-- how long to hold the prefix before the popup appears
	delay = 300,
	icons = {
		mappings = false, -- no per-mapping icons; the descriptions carry the meaning
	},
})

-- Group labels for the leader prefixes this config actually uses. Without
-- these, which-key shows a bare "+prefix" and you have to guess.
require("which-key").add({
	{ "<leader>c", group = "quickfix / copy" },
	{ "<leader>g", group = "git / goto" },
	{ "<leader>r", group = "restart / rotate" },
	{ "<leader>s", group = "search (telescope)" },
	{ "<leader>t", group = "test" },
	{ "<leader>z", group = "zdiff" },
})
