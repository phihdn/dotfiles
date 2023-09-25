return {
  "nvim-telescope/telescope.nvim",
  branch = '0.1.x', -- or tag = '0.1.3',
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  -- apply the config and additionally load fzf-native
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    --telescope.load_extension("fzf")
  end,

  opts = {
    defaults = {
      file_ignore_patterns = { ".git/", "node_modules" },
      layout_config = {
        height = 0.90,
        width = 0.90,
        preview_cutoff = 0,
        horizontal = { preview_width = 0.60 },
        vertical = { width = 0.55, height = 0.9, preview_cutoff = 0 },
        prompt_position = "top",
      },
      path_display = { "smart" },
      prompt_position = "top",
      prompt_prefix = " ",
      selection_caret = " ",
      sorting_strategy = "ascending",
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--hidden",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--trim", -- add this value
      },
      mappings = {
        i = {
          ["<C-k>"] = function(...)
            return require("telescope.actions").move_selection_previous(...)
          end, -- move to prev result
          ["<C-j>"] = function(...)
            return require("telescope.actions").move_selection_next(...)
          end, -- move to next result
        },
      },
    },
    pickers = {
      buffers = {
        prompt_prefix = "󰸩 ",
      },
      commands = {
        prompt_prefix = " ",
        layout_config = {
          height = 0.63,
          width = 0.78,
        },
      },
      command_history = {
        prompt_prefix = " ",
        layout_config = {
          height = 0.63,
          width = 0.58,
        },
      },
      git_files = {
        prompt_prefix = "󰊢 ",
        show_untracked = true,
      },
      find_files = {
        prompt_prefix = " ",
        find_command = { "fd", "-H" },
      },
      live_grep = {
        prompt_prefix = "󰱽 ",
      },
      grep_string = {
        prompt_prefix = "󰱽 ",
      },
    },
    extensions = {
      ["zf-native"] = {
        file = { -- options for sorting file-like items
          enable = true, -- override default telescope file sorter
          highlight_results = true, -- highlight matching text in results
          match_filename = true, -- enable zf filename match priority
        },
        generic = { -- options for sorting all other items
          enable = true, -- override default telescope generic item sorter
          highlight_results = true, -- highlight matching text in results
          match_filename = false, -- disable zf filename match priority
        },
      },
    },
  },
  cmd = "Telescope",
  keys = {
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files in cwd" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Find recent files" },
    { "<leader>fs", "<cmd>Telescope live_grep<cr>", desc = "Find string in cwd" },
    { "<leader>fc", "<cmd>Telescope grep_string<cr>", desc = "Find string under cursor in cwd" },
    { "<leader>f:", "<cmd>Telescope command_history<cr>", desc = "Find Command History" },
    -- git
    { "<leader>fgc", "<cmd>Telescope git_commits<CR>", desc = "Find commits" },
    { "<leader>fgs", "<cmd>Telescope git_status<CR>", desc = "Find status" },
  }
}