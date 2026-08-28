-- Catppuccin structure (broad plugin-integration coverage) with Gruvbox
-- Dark, Medium colors — the original morhetz/gruvbox palette.
-- Palette source: https://github.com/morhetz/gruvbox
return {
  "catppuccin/nvim",
  name = "catppuccin",
  priority = 1000,
  opts = {
    flavour = "mocha",
    transparent_background = true,
    color_overrides = {
      mocha = {
        rosewater = "#fb4934",
        flamingo = "#fb4934",
        red = "#fb4934",
        maroon = "#fb4934",
        pink = "#d3869b",
        mauve = "#d3869b",
        peach = "#fe8019",
        yellow = "#fabd2f",
        green = "#b8bb26",
        teal = "#8ec07c",
        sky = "#8ec07c",
        sapphire = "#8ec07c",
        blue = "#83a598",
        lavender = "#83a598",
        text = "#ebdbb2",
        subtext1 = "#d5c4a1",
        subtext0 = "#bdae93",
        overlay2 = "#a89984",
        overlay1 = "#928374",
        overlay0 = "#595959",
        surface2 = "#665c54",
        surface1 = "#504945",
        surface0 = "#3c3836",
        base = "#282828",
        mantle = "#1d2021",
        crust = "#141617",
      },
    },
    -- integrations off by default that this config uses
    integrations = {
      blink_cmp = true,
      diffview = true,
      fidget = true,
      mason = true,
      which_key = true,
    },
  },
  config = function(_, opts)
    require("catppuccin").setup(opts)
    vim.cmd.colorscheme("catppuccin")
  end,
}
