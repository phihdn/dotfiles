-- Render ":" commands on the classic bottom cmdline instead of noice's center popup
return {
  {
    "folke/noice.nvim",
    opts = {
      cmdline = {
        view = "cmdline",
      },
    },
  },
}
