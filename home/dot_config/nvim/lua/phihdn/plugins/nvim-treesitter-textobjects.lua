-- Query provider only: ships the `textobjects` treesitter query files that
-- mini.ai's gen_spec.treesitter() looks up; the selection keymaps themselves
-- live in plugins/mini.lua (vif/vac/via/vio ...).
vim.pack.add({ { src = "https://github.com/nvim-treesitter/nvim-treesitter-textobjects", version = "main" } })
