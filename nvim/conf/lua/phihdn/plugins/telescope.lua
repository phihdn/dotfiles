return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x", -- or tag = '0.1.3',
  dependencies = {
    "nvim-lua/plenary.nvim",
    { -- If encountering errors, see telescope-fzf-native README for installation instructions
      "nvim-telescope/telescope-fzf-native.nvim",

      -- `build` is used to run some command when the plugin is installed/updated.
      -- This is only run then, not every time Neovim starts up.
      build = "make",

      -- `cond` is a condition used to determine whether this plugin should be
      -- installed and loaded.
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
    { "nvim-telescope/telescope-ui-select.nvim" },

    -- Useful for getting pretty icons, but requires a Nerd Font.
    { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
    "ThePrimeagen/harpoon",
    "folke/todo-comments.nvim",
  },
  -- apply the config and additionally load fzf-native
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    telescope.setup({
      extensions = {
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({}),
        },
      },
    })

    -- Enable Telescope extensions if they are installed
    pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "ui-select")
    pcall(require("telescope").load_extension, "harpoon")
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
        prompt_prefix = " 󰸩 ",
      },
      commands = {
        prompt_prefix = "   ",
        layout_config = {
          height = 0.63,
          width = 0.78,
        },
      },
      command_history = {
        prompt_prefix = "  ",
        layout_config = {
          height = 0.63,
          width = 0.58,
        },
      },
      git_files = {
        prompt_prefix = " 󰊢 ",
        show_untracked = true,
      },
      find_files = {
        prompt_prefix = "   ",
        find_command = { "fd", "-H" },
      },
      live_grep = {
        prompt_prefix = " 󰱽 ",
      },
      grep_string = {
        prompt_prefix = " 󰱽 ",
      },
    },
    extensions = {},
  },
  cmd = "Telescope",
  keys = {
    -- search
    { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "[S]earch [H]elp" },
    { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "[S]earch [K]eymaps" },
    { "<leader>sf", "<cmd>Telescope find_files<cr>", desc = "[S]earch [F]iles" },
    { "<leader>ss", "<cmd>Telescope<cr>", desc = "[S]earch [S]elect Telescope" },
    { "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "[S]earch current [W]ord" },
    { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "[S]earch by [G]rep" },
    { "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "[S]earch Workspace [D]iagnostics" },
    { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "[S]earch current buffer [d]iagnostics" },
    { "<leader>sr", "<cmd>Telescope resume<cr>", desc = "[S]earch [R]esume" },
    { "<leader>s.", "<cmd>Telescope oldfiles<cr>", desc = '[S]earch Recent Files ("." for repeat)' },
    { "<leader><leader>", "<cmd>Telescope buffers<cr>", desc = "[ ] Find existing buffers" },
    {
      "<leader>/",
      function()
        require("telescope.builtin").current_buffer_fuzzy_find(require("telescope.themes").get_dropdown({
          winblend = 10,
          previewer = false,
        }))
      end,
      desc = "[/] Fuzzily search in current buffer",
    },
    -- It's also possible to pass additional configuration options.
    --  See `:help telescope.builtin.live_grep()` for information about particular keys
    {
      "<leader>s/",
      function()
        require("telescope.builtin").live_grep({
          grep_open_files = true,
          prompt_title = "Live Grep in Open Files",
        })
      end,
      desc = "[S]earch [/] in Open Files",
    },

    -- Shortcut for searching your Neovim configuration files
    {
      "<leader>sn",
      function()
        require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
      end,
      desc = "[S]earch [N]eovim files",
    },

    { '<leader>s"', "<cmd>Telescope registers<cr>", desc = '[S]earch ["]Registers' },
    -- { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "[S]earch [A]uto Commands" },
    -- { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "[S]earch [B]uffer" },
    -- { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "[S]earch [C]ommand History" },
    -- { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "[S]earch [C]ommands" },
    -- { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "[S]earch [H]ighlight Groups" },
    -- { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "[S]earch [M]an Pages" },
    -- { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "[S]earch [M]arks" },
    -- { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "[S]earch vim [O]ptions" },
    -- {
    --   "<leader>,",
    --   "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
    --   desc = "Switch Buffer",
    -- },
    -- { "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Grep (cwd)" },
    -- { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
    -- { "<leader><space>", "<cmd>Telescope find_files<cr>", desc = "Find Files (cwd)" },
    -- -- find
    -- { "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "[F]ind [B]uffers" },
    -- { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "[F]ind files ([G]it-files)" },
    -- { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "[F]ind [R]ecent files" },
    -- { "<leader>fh", ":Telescope harpoon marks<cr>", desc = "[F]ind [H]arpoon marks" },
    -- -- git
    -- { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Search git commits" },
    -- { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Search git status" },
  },
}
