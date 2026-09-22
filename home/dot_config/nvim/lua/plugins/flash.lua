-- Label-based motion on s/S. mini.surround lives on the gs prefix precisely so
-- flash can own plain s here.
require("flash").setup({})

vim.keymap.set({ "n", "x", "o" }, "s", function()
	require("flash").jump()
end, { desc = "Fla[s]h" })
vim.keymap.set({ "n", "x", "o" }, "S", function()
	require("flash").treesitter()
end, { desc = "Flash Tree[S]itter" })
