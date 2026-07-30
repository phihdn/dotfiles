return {
  "ibhagwan/fzf-lua",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function(_, opts)
    local fzf = require("fzf-lua")
    fzf.setup(opts)
    -- replace vim.ui.select (code actions, etc.) with an fzf-lua picker
    fzf.register_ui_select()
  end,
  opts = {
    files = { cwd_prompt = false },
    grep = {
      rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden --glob=!.git/ --max-columns=4096 -e",
    },
  },
  keys = {
    {
      "<leader>ff",
      function()
        require("fzf-lua").files()
      end,
      desc = "[F]ind [F]iles in project directory",
    },
    {
      "<leader>fg",
      function()
        require("fzf-lua").live_grep()
      end,
      desc = "[F]ind by [G]repping in project directory",
    },
    {
      "<leader>fn",
      function()
        require("fzf-lua").files({ cwd = vim.fn.stdpath("config") })
      end,
      desc = "[F]ind in [N]eovim configuration",
    },
    {
      "<leader>fh",
      function()
        require("fzf-lua").helptags()
      end,
      desc = "[F]ind [H]elp",
    },
    {
      "<leader>fk",
      function()
        require("fzf-lua").keymaps()
      end,
      desc = "[F]ind [K]eymaps",
    },
    {
      "<leader>fb",
      function()
        require("fzf-lua").buffers()
      end,
      desc = "[F]ind [B]uffers",
    },
    {
      "<leader>fz",
      function()
        require("fzf-lua").builtin()
      end,
      desc = "[F]ind f[z]f-lua builtin pickers",
    },
    {
      "<leader>fw",
      function()
        require("fzf-lua").grep_cword()
      end,
      desc = "[F]ind current [W]ord",
    },
    {
      "<leader>fW",
      function()
        require("fzf-lua").grep_cWORD()
      end,
      desc = "[F]ind current [W]ORD",
    },
    {
      "<leader>fd",
      function()
        require("fzf-lua").diagnostics_document()
      end,
      desc = "[F]ind buffer [D]iagnostics",
    },
    {
      "<leader>fD",
      function()
        require("fzf-lua").diagnostics_workspace()
      end,
      desc = "[F]ind workspace [D]iagnostics",
    },
    {
      "<leader>fr",
      function()
        require("fzf-lua").resume()
      end,
      desc = "[F]ind [R]esume",
    },
    {
      "<leader>fo",
      function()
        require("fzf-lua").oldfiles()
      end,
      desc = "[F]ind [O]ld Files",
    },
    {
      '<leader>f"',
      function()
        require("fzf-lua").registers()
      end,
      desc = '[F]ind ["]Registers',
    },
    {
      "<leader>:",
      function()
        require("fzf-lua").command_history()
      end,
      desc = "Command History",
    },
    {
      "<leader><leader>",
      function()
        require("fzf-lua").buffers()
      end,
      desc = "[ ] Find existing buffers",
    },
    {
      "<leader>/",
      function()
        require("fzf-lua").lgrep_curbuf()
      end,
      desc = "[/] Live grep the current buffer",
    },
    {
      "<leader>gc",
      function()
        require("fzf-lua").git_commits()
      end,
      desc = "Search [g]it [c]ommits",
    },
    {
      "<leader>gs",
      function()
        require("fzf-lua").git_status()
      end,
      desc = "Search [g]it [s]tatus",
    },
  },
}
