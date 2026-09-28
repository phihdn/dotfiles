vim.pack.add({ "https://github.com/folke/flash.nvim" })

require("flash").setup()

-- stylua: ignore start
vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Fla[s]h" })
vim.keymap.set({ "n", "x", "o" }, "S", function() require("flash").treesitter() end, { desc = "Flash Tree[S]itter" })
-- stylua: ignore end
