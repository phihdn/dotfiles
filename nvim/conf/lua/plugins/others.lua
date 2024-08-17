return {
  {
    "christoomey/vim-tmux-navigator",
    event = "VeryLazy",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<c-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Go to Left Window" },
      { "<c-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Go to Lower Window" },
      { "<c-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Go to Upper Window" },
      { "<c-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Go to Right Window" },
    },
  }, -- tmux & split window navigation
}
