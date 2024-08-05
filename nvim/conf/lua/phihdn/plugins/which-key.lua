return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  lazy = true,
  init = function()
    vim.o.timeout = true
    vim.o.timeoutlen = 500
  end,
  opts = {
    plugins = {
      marks = false, -- shows a list of your marks on ' and `
      registers = false, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
      spelling = {
        enabled = true,
        suggestions = 20,
      },

      -- the presets plugin, adds help for a bunch of default keybindings in Neovim
      -- No actual key bindings are created
      presets = {
        operators = false, -- adds help for operators like d, y, ...
        motions = false, -- adds help for motions
        text_objects = false, -- help for text objects triggered after entering an operator
        windows = false, -- default bindings on <c-w>
        nav = false, -- misc bindings to work with windows
        z = false, -- bindings for folds, spelling and others prefixed with z
        g = false, -- bindings for prefixed with g
      },
    },
    icons = {
      breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
      separator = require("phihdn.core.icons").ui.BoldArrowRight, -- symbol used between a key and it's label
      group = "+", -- symbol prepended to a group
    },
    keys = {
      scroll_down = "<c-d>", -- binding to scroll down inside the popup
      scroll_up = "<c-u>", -- binding to scroll up inside the popup
    },
    -- window = {
    --   border = "none", -- none, single, double, shadow
    --   position = "bottom", -- bottom, top
    --   margin = { 2, 0, 2, 0 }, -- extra window margin [top, right, bottom, left]
    --   padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
    --   winblend = 0,
    --   zindex = 1000, -- positive value to position WhichKey above other floating windows.
    -- },
    layout = {
      height = { min = 4, max = 25 }, -- min and max height of the columns
      width = { min = 20, max = 50 }, -- min and max width of the columns
      spacing = 3, -- spacing between columns
      align = "left", -- align columns left, center or right
    },
    filter = function(mapping)
      -- example to exclude mappings without a description
      -- return mapping.desc and mapping.desc ~= ""
      return true
    end,
    -- hidden = { "<silent>", "<cmd>", "<Cmd>", "<CR>", "call", "lua", "^:", "^ " }, -- hide mapping boilerplate
    show_help = true, -- show help message on the command line when the popup is visible
    show_keys = true,
    -- Disabled by default for Telescope
    disable = {
      buftypes = {},
      filetypes = { "TelescopePrompt" },
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    wk.add({
      { "<leader>c", group = "Code" }, -- group
      { "<leader>u", group = "UI" }, -- group
      {
        "<leader>uv",
        require("phihdn.helpers.utils").toggle_set_color_column,
        desc = "Toggle Color Line",
        mode = { "n", "v" },
      }, -- command
      {
        "<leader>uc",
        require("phihdn.helpers.utils").toggle_cursor_line,
        desc = "Toggle Cursor Line",
        mode = { "n", "v" },
      }, -- command
      { "<leader>s", group = "Search" }, -- group
    })
    wk.add({
      { "<C-w>v", desc = "Split Windows Vertically" },
      { "<C-w>s", desc = "Split Windows Horizontally" },
      { "<C-w>=", desc = "Balance Windows" },
      { "<C-w>|", desc = "Maximize Window" },
      { "<C-w>o", desc = "Close Other Windows" },
      { "<C-w>c", desc = "Close Window" },
      { "<C-w>q", desc = "Quit Window" },
    })
  end,
}
