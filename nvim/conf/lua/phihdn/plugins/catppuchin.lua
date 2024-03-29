return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd([[ colorscheme catppuccin ]])
    vim.cmd([[ hi CursorLine guibg=#403658 ]])
    vim.cmd([[ hi ColorColumn guibg=#6e738d ]])
  end,
  opts = {
    flavour = "macchiato", -- latte, frappe, macchiato, or mocha
    transparent_background = true,
    show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
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
      indent_blankline = {
        enabled = true,
        scope_color = "text", -- catppuccin color (eg. `lavender`) Default: text
        colored_indent_levels = false,
      },
      mini = {
        enabled = true,
        indentscope_color = "", -- catppuccin color (eg. `lavender`) Default: text
      },
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
