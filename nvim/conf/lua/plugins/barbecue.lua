return {
  "utilyre/barbecue.nvim",
  dependencies = {
    "SmiteshP/nvim-navic",
    "nvim-tree/nvim-web-devicons",
  },
  name = "barbecue",
  enabled = true,
  event = "BufEnter",
  opts = {
    theme = "catppuccin-mocha", -- catppuccin-latte, catppuccin-frappe, catppuccin-macchiato, catppuccin-mocha
  },
}
