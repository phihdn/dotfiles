-- Only addition to Sam's upstream config: a popup listing what keys follow a
-- prefix, for learning the mappings. Group labels below cover the leader
-- prefixes upstream actually uses; without them which-key shows a bare "+prefix".
require("which-key").setup({
	preset = "helix",
	delay = 300,
	icons = { mappings = false },
})

require("which-key").add({
	{ "<leader>c", group = "quickfix / copy" },
	{ "<leader>g", group = "git / goto" },
	{ "<leader>r", group = "restart / rotate" },
	{ "<leader>s", group = "search (telescope)" },
	{ "<leader>t", group = "test" },
	{ "<leader>z", group = "zdiff" },
})
