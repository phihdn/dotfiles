return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = { "markdown" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  ---@module 'render-markdown'
  init = function()
    -- Gruvbox Material palette, matching the catppuccin color_overrides in
    -- plugins/catppuccin-gruvbox.lua
    local palette = {
      bg = "#1d2021",
      red = "#ea6962",
      green = "#a9b665",
      yellow = "#d8a657",
      blue = "#7daea3",
      aqua = "#89b482",
      orange = "#e78a4e",
    }

    -- Headline backgrounds (rotate through the accent colors)
    vim.cmd(string.format([[highlight Headline1Bg guifg=%s guibg=%s gui=bold]], palette.bg, palette.red))
    vim.cmd(string.format([[highlight Headline2Bg guifg=%s guibg=%s gui=bold]], palette.bg, palette.green))
    vim.cmd(string.format([[highlight Headline3Bg guifg=%s guibg=%s gui=bold]], palette.bg, palette.yellow))
    vim.cmd(string.format([[highlight Headline4Bg guifg=%s guibg=%s gui=bold]], palette.bg, palette.blue))
    vim.cmd(string.format([[highlight Headline5Bg guifg=%s guibg=%s gui=bold]], palette.bg, palette.aqua))
    vim.cmd(string.format([[highlight Headline6Bg guifg=%s guibg=%s gui=bold]], palette.bg, palette.orange))

    vim.cmd(string.format([[highlight Headline1Fg guifg=%s gui=bold]], palette.red))
    vim.cmd(string.format([[highlight Headline2Fg guifg=%s gui=bold]], palette.green))
    vim.cmd(string.format([[highlight Headline3Fg guifg=%s gui=bold]], palette.yellow))
    vim.cmd(string.format([[highlight Headline4Fg guifg=%s gui=bold]], palette.blue))
    vim.cmd(string.format([[highlight Headline5Fg guifg=%s gui=bold]], palette.aqua))
    vim.cmd(string.format([[highlight Headline6Fg guifg=%s gui=bold]], palette.orange))
  end,
  opts = {
    render_modes = { "n", "c", "t" },
    -- anti_conceal re-renders the cursor line on every CursorMoved, which
    -- makes holding j/k laggy in large files; static decorations instead
    anti_conceal = { enabled = false },
    -- align with the bigfile guard in core/autocmds.lua
    max_file_size = 1.5,
    heading = {
      sign = false,
      icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
      backgrounds = {
        "Headline1Bg",
        "Headline2Bg",
        "Headline3Bg",
        "Headline4Bg",
        "Headline5Bg",
        "Headline6Bg",
      },
      foregrounds = {
        "Headline1Fg",
        "Headline2Fg",
        "Headline3Fg",
        "Headline4Fg",
        "Headline5Fg",
        "Headline6Fg",
      },
    },
    code = {
      sign = false,
      width = "block",
      right_pad = 1,
    },
    bullet = {
      enabled = true,
    },
  },
}
