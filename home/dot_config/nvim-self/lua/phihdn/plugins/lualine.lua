-- At which column count start to make the elements smaller or hide certain elements?
local lualine_trunc_margin = 80

local function truncateCondition()
  return vim.o.columns >= lualine_trunc_margin
end

local function getColumnPosition()
  local col = "%v"
  local max_col = "%{virtcol('$')-1}"
  if not truncateCondition() then
    return string.format("%s", col)
  else
    -- return string.format("%s\u{23ae}%s", col, max_col)
    return string.format("%s|%s", col, max_col)
  end
end

local function getRowPosition()
  local row = "%l"
  local max_row = "%L"
  if not truncateCondition() then
    return string.format("%s", row)
  else
    -- return string.format("%s\u{23ae}%s", row, max_row)
    return string.format("%s|%s", row, max_row)
  end
end

return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "meuter/lualine-so-fancy.nvim",
  },
  enabled = true,
  lazy = false,
  event = { "BufReadPost", "BufNewFile", "VeryLazy" },
  config = function()
    -- local custom_gruvbox = require("lualine.themes.gruvbox")
    -- Change the background of lualine_c section for normal mode
    -- custom_gruvbox.normal.c.bg = "#112233"

    local custom_gruvbox = require("lualine.themes.gruvbox") -- start with gruvbox

    -- Gruvbox Material palette, matching the catppuccin color_overrides in
    -- plugins/catppuccin-gruvbox.lua
    local colors = {
      bg = "#1d2021",
      fg = "#ebdbb2",
      yellow = "#d8a657",
      cyan = "#89b482",
      darkblue = "#292929",
      green = "#a9b665",
      orange = "#e78a4e",
      violet = "#d3869b",
      magenta = "#d3869b",
      blue = "#7daea3",
      red = "#ea6962",
    }

    custom_gruvbox.normal = {
      a = { fg = colors.bg, bg = colors.blue, gui = "bold" },
      b = { fg = colors.fg, bg = colors.darkblue },
      c = { fg = colors.fg, bg = colors.bg },
    }

    custom_gruvbox.insert = {
      a = { fg = colors.bg, bg = colors.green, gui = "bold" },
      b = { fg = colors.fg, bg = colors.darkblue },
      c = { fg = colors.fg, bg = colors.bg },
    }

    custom_gruvbox.visual = {
      a = { fg = colors.bg, bg = colors.magenta, gui = "bold" },
      b = { fg = colors.fg, bg = colors.darkblue },
      c = { fg = colors.fg, bg = colors.bg },
    }

    custom_gruvbox.replace = {
      a = { fg = colors.bg, bg = colors.red, gui = "bold" },
      b = { fg = colors.fg, bg = colors.darkblue },
      c = { fg = colors.fg, bg = colors.bg },
    }

    custom_gruvbox.command = {
      a = { fg = colors.bg, bg = colors.yellow, gui = "bold" },
      b = { fg = colors.fg, bg = colors.darkblue },
      c = { fg = colors.fg, bg = colors.bg },
    }

    custom_gruvbox.inactive = {
      a = { fg = colors.fg, bg = colors.bg, gui = "bold" },
      b = { fg = colors.fg, bg = colors.bg },
      c = { fg = colors.fg, bg = colors.bg },
    }

    local icons = require("phihdn.core.icons")
    require("lualine").setup({
      options = {
        -- theme = "auto",
        -- theme = "gruvbox-material",
        theme = custom_gruvbox,
        globalstatus = true,
        icons_enabled = true,
        component_separators = { left = "│", right = "│" },
        -- component_separators = { left = "|", right = "|" },
        section_separators = { left = "", right = "" },
        disabled_filetypes = {
          statusline = {
            "alfa-nvim",
            "help",
            "neo-tree",
            "Trouble",
            "spectre_panel",
            "toggleterm",
          },
          winbar = {},
        },
      },
      sections = {
        lualine_a = {
          { "fancy_mode", width = 1 },
        },
        lualine_b = {
          { "fancy_branch" },
          { "fancy_diff" },
        },
        lualine_c = {
          {
            "filename",
            path = 1, -- 2 for full path
            symbols = {
              modified = " " .. icons.ui.BoldFileEdit .. " ",
              readonly = " " .. icons.ui.BoldLock .. " ",
              -- unnamed = "  ",
            },
          },
          { "fancy_searchcount" },
        },
        lualine_x = {
          { "fancy_macro" },
          {
            "fancy_diagnostics",
            sources = { "nvim_lsp" },
            symbols = {
              error = icons.diagnostics.BoldError .. " ",
              warn = icons.diagnostics.BoldWarning .. " ",
              info = icons.diagnostics.BoldInformation .. " ",
            },
          },
          { "fancy_lsp_servers" },
        },
        lualine_y = {
          { "fancy_filetype", ts_icon = "" },
        },
        lualine_z = {
          getRowPosition,
          getColumnPosition,
        },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        -- lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      extensions = { "oil", "neo-tree", "lazy", "nvim-tree", "trouble", "quickfix", "mason" },
    })
  end,
}
