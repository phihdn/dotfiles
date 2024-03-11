return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x", -- or tag = '0.1.3',
  dependencies = {
    "nvim-lua/plenary.nvim",
    "ThePrimeagen/harpoon",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-telescope/telescope-ui-select.nvim",
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
    telescope.load_extension("harpoon")
    telescope.load_extension("fzf")
    telescope.load_extension("ui-select")
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
    {
      "<leader>,",
      "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
      desc = "Switch Buffer",
    },
    { "<leader>/", "<cmd>Telescope live_grep<cr>", desc = "Grep (cwd)" },
    { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
    { "<leader><space>", "<cmd>Telescope find_files<cr>", desc = "Find Files (cwd)" },
    -- find
    { "<leader>fb", "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>", desc = "[F]ind [B]uffers" },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "[F]ind [F]iles (cwd)" },
    { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "[F]ind files ([G]it-files)" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "[F]ind [R]ecent files" },
    { "<leader>fh", ":Telescope harpoon marks<cr>", desc = "[F]ind [H]arpoon marks" },
    -- git
    { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Search git commits" },
    { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Search git status" },
    -- search
    { '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Search Registers" },
    { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "[S]earch [A]uto Commands" },
    { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "[S]earch [B]uffer" },
    { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "[S]earch [C]ommand History" },
    { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "[S]earch [C]ommands" },
    { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "[S]earch current buffer [d]iagnostics" },
    { "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "[S]earch Workspace [D]iagnostics" },
    { "<leader>sg", "<cmd>Telescope live_grep<cr>", desc = "[S]earch [G]rep in cwd" },
    { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "[S]earch [h]elp Pages" },
    { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "[S]earch [H]ighlight Groups" },
    { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "[S]earch [K]ey Maps" },
    { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "[S]earch [M]an Pages" },
    { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "[S]earch [M]arks" },
    { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "[S]earch vim [O]ptions" },
    { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
    { "<leader>sw", "<cmd>Telescope grep_string<cr>", desc = "[S]earch [W]ord in cwd" },
  },
}
