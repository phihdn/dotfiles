return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "meuter/lualine-so-fancy.nvim",
  },
  event = "VeryLazy",
  opts = function(_, opts)
    opts.options.theme = "catppuccin"
    opts.options.component_separators = { left = "│", right = "│" }
    --opts.options.component_separators = { left = "|", right = "|" }
    opts.options.section_separators = { left = "", right = "" }
    opts.sections.lualine_a = {
      { "fancy_mode", width = 1 },
    }
    opts.sections.lualine_b = {
      { "fancy_branch" },
      { "fancy_diff" },
    }
    opts.sections.lualine_z = {
      { "fancy_lsp_servers" },
    }
  end,
}
