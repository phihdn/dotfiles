-- Query provider only: ships the `textobjects` treesitter query files that
-- mini.ai's gen_spec.treesitter() looks up; the selection keymaps themselves
-- live in plugins/mini.lua (vif/vac/via/vio ...).
return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
}
