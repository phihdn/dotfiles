-- At which column count start to make the elements smaller or hide certain elements?
local lualine_trunc_margin = 80

local function truncateCondition()
  return vim.o.columns >= lualine_trunc_margin
end

-- Fixed-width position fields so the section doesn't resize while moving the
-- cursor. The current line is padded to exactly the digit count of the
-- buffer's total ("320|799", " 32|799"), so no dead space is reserved.
local function getColumnPosition()
  if not truncateCondition() then
    return "%2v"
  end
  return "%2v|%3{virtcol('$')-1}"
end

local function getRowPosition()
  local width = #tostring(vim.api.nvim_buf_line_count(0))
  if not truncateCondition() then
    return "%" .. width .. "l"
  end
  return "%" .. width .. "l|%L"
end

-- Contextual components — each renders empty (hides) when there is nothing to say
local function sleuthIndent()
  -- indent as detected by vim-sleuth; makes a wrong guess visible at a glance
  if vim.bo.buftype ~= "" then
    return ""
  end
  local sw = vim.bo.shiftwidth ~= 0 and vim.bo.shiftwidth or vim.bo.tabstop
  return vim.bo.expandtab and (sw .. "sp") or "tab"
end

local function markdownWordcount()
  if vim.bo.filetype ~= "markdown" then
    return ""
  end
  return vim.fn.wordcount().words .. "w"
end

local function autoformatOff()
  -- conform.nvim format-on-save honors these toggles; warn while it's off
  if vim.g.disable_autoformat or vim.b.disable_autoformat then
    return "fmt!"
  end
  return ""
end

local function abnormalEncoding()
  local enc = vim.bo.fileencoding
  return (enc ~= "" and enc ~= "utf-8") and enc or ""
end

local function abnormalFileformat()
  if vim.bo.fileformat == "unix" then
    return ""
  end
  return vim.bo.fileformat == "dos" and "CRLF" or vim.bo.fileformat
end

return {
  "nvim-lualine/lualine.nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
    "meuter/lualine-so-fancy.nvim",
  },
  event = "VeryLazy",
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
            require("lazy.status").updates,
            cond = require("lazy.status").has_updates,
            color = { fg = colors.orange },
          },
          { markdownWordcount },
          { autoformatOff, color = { fg = colors.red, gui = "bold" } },
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
          { sleuthIndent, cond = truncateCondition },
          { abnormalEncoding, color = { fg = colors.red, gui = "bold" } },
          { abnormalFileformat, color = { fg = colors.red, gui = "bold" } },
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
