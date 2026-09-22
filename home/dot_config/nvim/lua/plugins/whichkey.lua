-- Only addition to Sam's upstream config: a popup listing what keys follow a
-- prefix, for learning the mappings. Group labels below cover the leader
-- prefixes upstream actually uses; without them which-key shows a bare "+prefix".
require("which-key").setup({
	preset = "helix",
	delay = 300,
	icons = { mappings = false },
})

require("which-key").add({
	{ "<leader>b", group = "buffer" },
	{ "<leader>c", group = "code / quickfix" },
	{ "<leader>e", group = "explorer" },
	{ "<leader>f", group = "find" },
	{ "<leader>g", group = "git / goto" },
	{ "<leader>r", group = "restart / rename / rotate" },
	{ "<leader>s", group = "split" },
	{ "<leader>t", group = "test" },
	{ "<leader>u", group = "ui / toggles" },
	{ "<leader>x", group = "diagnostics" },
	{ "<leader>z", group = "zdiff" },
	{ "gs", group = "surround" },
})
