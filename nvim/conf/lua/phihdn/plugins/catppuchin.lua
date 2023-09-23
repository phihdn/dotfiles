return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd([[ colorscheme catppuccin ]])
  end,
  opts = {
    flavour = "macchiato", -- latte, frappe, macchiato, or mocha
    transparent_background = true,
    --color_overrides = {
    --  all = {
    --    surface0 = "#444444",
    --    surface1 = "#666666",
    --    surface2 = "#a3a7bc",
    --    surface3 = "#a3a7bc",
    --  },
    --},
    integrations = {
      nvimtree = true,
      cmp = true,
      fidget = true,
      gitsigns = true,
      harpoon = true,
      lsp_trouble = true,
      mason = true,
      neotest = true,
      noice = true,
      notify = true,
      octo = true,
      telescope = {
        enabled = true,
      },
      treesitter = true,
      treesitter_context = false,
      symbols_outline = true,
      illuminate = true,
      which_key = true,
      barbecue = {
        dim_dirname = true,
        bold_basename = true,
        dim_context = false,
        alt_background = false,
      },
      native_lsp = {
        enabled = true,
        virtual_text = {
          errors = { "italic" },
          hints = { "italic" },
          warnings = { "italic" },
          information = { "italic" },
        },
        underlines = {
          errors = { "underline" },
          hints = { "underline" },
          warnings = { "underline" },
          information = { "underline" },
        },
      },
    },
  },
}
