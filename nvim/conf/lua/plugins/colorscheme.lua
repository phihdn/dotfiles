return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    config = function(_, opts)
      require("catppuccin").setup(opts)
    end,
    opts = function()
      return {
        flavour = "mocha", -- latte, frappe, macchiato, or mocha
        transparent_background = true,
        background = {
          light = "latte",
          dark = "mocha",
        },
        show_end_of_buffer = false, -- shows the '~' characters after the end of buffers
        integrations = {
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
      }
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin-mocha",
    },
  },
}
