-- Kanagawa Dragon — https://github.com/rebelot/kanagawa.nvim
return {
  "rebelot/kanagawa.nvim",
  lazy = false,
  priority = 1000,
  opts = {
    transparent = true,
    -- the gutter keeps the window background instead of a tinted column
    colors = {
      theme = {
        all = {
          ui = { bg_gutter = "none" },
        },
      },
    },
    overrides = function(colors)
      local theme = colors.theme
      -- diagnostic virtual text: tint the background with a heavily blended
      -- wash of the message's own foreground so severity reads at a glance
      local diagnosticColor = function(color)
        local c = require("kanagawa.lib.color")
        return { fg = color, bg = c(color):blend(theme.ui.bg, 0.95):to_hex() }
      end
      return {
        -- transparent floats, matching `transparent` above
        NormalFloat = { bg = "none" },
        FloatBorder = { bg = "none" },
        FloatTitle = { bg = "none" },
        -- floats that should stay dark and borderless regardless
        NormalDark = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
        LazyNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
        MasonNormal = { fg = theme.ui.fg_dim, bg = theme.ui.bg_m3 },
        -- completion menu, dark against the transparent editor
        Pmenu = { fg = theme.ui.shade0, bg = theme.ui.bg_p1 },
        PmenuSel = { fg = "NONE", bg = theme.ui.bg_p2 },
        PmenuSbar = { bg = theme.ui.bg_m1 },
        PmenuThumb = { bg = theme.ui.bg_p2 },
        DiagnosticVirtualTextHint = diagnosticColor(theme.diag.hint),
        DiagnosticVirtualTextInfo = diagnosticColor(theme.diag.info),
        DiagnosticVirtualTextWarn = diagnosticColor(theme.diag.warning),
        DiagnosticVirtualTextError = diagnosticColor(theme.diag.error),
        -- markdown inline markup, which the theme leaves largely unstyled
        ["@markup.link.url.markdown_inline"] = { link = "Special" }, -- (url)
        ["@markup.link.label.markdown_inline"] = { link = "WarningMsg" }, -- [label]
        ["@markup.italic.markdown_inline"] = { link = "Exception" }, -- *italic*
        ["@markup.raw.markdown_inline"] = { link = "String" }, -- `code`
        ["@markup.list.markdown"] = { link = "Function" }, -- + list
        ["@markup.quote.markdown"] = { link = "Error" }, -- > blockquote
        ["@markup.list.checked.markdown"] = { link = "WarningMsg" }, -- - [x] done
      }
    end,
  },
  config = function(_, opts)
    require("kanagawa").setup(opts)
    vim.cmd.colorscheme("kanagawa-dragon")
  end,
}
