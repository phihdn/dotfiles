return {
  "nvim-telescope/telescope.nvim",
  branch = "master", -- using master to fix issues with deprecated to definition warnings
  -- '0.1.x' for stable ver.
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    { "nvim-telescope/telescope-ui-select.nvim" },
    "folke/todo-comments.nvim",
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local trouble = require("trouble.sources.telescope")
    local icons = require("phihdn.core.icons")

    vim.api.nvim_create_autocmd("FileType", {
      pattern = "TelescopeResults",
      callback = function(ctx)
        vim.api.nvim_buf_call(ctx.buf, function()
          vim.fn.matchadd("TelescopeParent", "\t\t.*$")
          vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
        end)
      end,
    })

    -- local function formattedName(_, path)
    --   local tail = vim.fs.basename(path)
    --   local parent = vim.fs.dirname(path)
    --   if parent == "." then
    --     return tail
    --   end
    --   return string.format("%s\t\t%s", tail, parent)
    -- end

    telescope.setup({
      -- borderchars = { "█", " ", "▀", "█", "█", " ", " ", "▀" },
      defaults = {
        mappings = {
          i = {
            -- quit on single first escape
            ["<esc>"] = actions.close,
            ["<C-u>"] = false,
            ["<C-d>"] = false,
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-t>"] = trouble.open,
          },

          n = {
            ["<C-k>"] = actions.move_selection_previous,
            ["<C-j>"] = actions.move_selection_next,
            ["<C-t>"] = trouble.open,
          },
        },
        -- path_display = formattedName,
        path_display = {
          "filename_first",
        },
        previewer = true,
        prompt_prefix = " ",
        selection_caret = "\u{1FB87} ", -- ▎ left one quarter block (\u{258E}) and 🮇 right one quarter block (\u{1FB87})
        file_ignore_patterns = { "%.git/.", "node_modules", "package-lock.json" },
        initial_mode = "insert",
        select_strategy = "reset",
        sorting_strategy = "ascending",
        color_devicons = true,
        set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
        layout_config = {
          height = 0.90,
          width = 0.90,
          preview_cutoff = 0,
          horizontal = { preview_width = 0.60 },
          vertical = { width = 0.55, height = 0.9, preview_cutoff = 0 },
          prompt_position = "top",
        },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
          "--glob=!.git/",
        },
      },
      pickers = {
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
          only_sort_text = true,
          previewer = true,
        },
        grep_string = {
          prompt_prefix = " 󰱽 ",
          only_sort_text = true,
          previewer = true,
        },
        buffers = {
          prompt_prefix = " 󰸩 ",
          mappings = {
            i = {
              ["<c-d>"] = actions.delete_buffer,
            },
            n = {
              ["<c-d>"] = actions.delete_buffer,
            },
          },
          previewer = false,
          -- initial_mode = "normal",
          theme = "dropdown",
          layout_config = {
            height = 0.4,
            width = 0.6,
            prompt_position = "top",
            preview_cutoff = 120,
          },
        },
        current_buffer_fuzzy_find = {
          previewer = false,
          theme = "dropdown",
          layout_config = {
            height = 0.4,
            width = 0.6,
            prompt_position = "top",
            preview_cutoff = 120,
          },
        },
        lsp_references = {
          show_line = false,
          previewer = true,
        },
        treesitter = {
          show_line = false,
          previewer = true,
        },
        colorscheme = {
          enable_preview = true,
        },
      },
      extensions = {
        fzf = {
          fuzzy = true, -- false will only do exact matching
          override_generic_sorter = true, -- override the generic sorter
          override_file_sorter = true, -- override the file sorter
          case_mode = "smart_case", -- or "ignore_case" or "respect_case"
        },
        ["ui-select"] = {
          require("telescope.themes").get_cursor({ -- or write a minimal custom config
            layout_strategy = "center",
            layout_config = {
              height = 0.4,
              width = 0.6,
            },
            sorting_strategy = "ascending",
            initial_mode = "insert",
            prompt_prefix = " ",
            results_title = false,
            previewer = false,
          }),
        },
        package_info = {
          -- Optional theme (the extension doesn't set a default theme)
          -- theme = "ivy",
        },
        -- frecency = {
        --   default_workspace = "CWD",
        --   show_scores = true,
        --   show_unindexed = true,
        --   disable_devicons = false,
        --   ignore_patterns = {
        --     "*.git/*",
        --     "*/tmp/*",
        --     "*/lua-language-server/*",
        --   },
        -- },
      },
    })

    vim.api.nvim_set_hl(0, "TelescopeSelectionCaret", {
      fg = "#7E9CD8", -- dragonBlue
      -- bg = "#1F1F28", -- sumiInk1
    })

    -- Enable Telescope extensions if they are installed
    pcall(require("telescope").load_extension, "fzf")
    pcall(require("telescope").load_extension, "ui-select")
  end,
  cmd = "Telescope",
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "[F]ind [F]iles in project directory" },
    { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "[F]ind by [G]repping in project directory" },
    {
      "<leader>fn",
      function()
        require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
      end,
      desc = "[F]ind in [N]eovim configuration",
    },
    { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "[F]ind [H]elp" },
    { "<leader>fk", "<cmd>Telescope keymaps<CR>", desc = "[F]ind [K]eymaps" },
    { "<leader>fw", "<cmd>Telescope grep_string<CR>", desc = "[F]ind current [W]ord" },
    { "<leader>fd", "<cmd>Telescope diagnostics bufnr=0<CR>", desc = "[F]ind current buffer [D]iagnostics" },
    { "<leader>fD", "<cmd>Telescope diagnostics<CR>", desc = "[F]ind Workspace [D]iagnostics" },
    { "<leader>fr", "<cmd>Telescope resume<CR>", desc = "[F]ind [R]esume" },
    { "<leader>fo", "<cmd>Telescope oldfiles<CR>", desc = "[F]ind [O]ld Files" },
    {
      "<leader><leader>",
      "<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>",
      desc = "[ ] Find existing buffers",
    },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "[F]ind [B]uffers" },
    {
      "<leader>/",
      function()
        require("telescope.builtin").current_buffer_fuzzy_find()
      end,
      desc = "[/] Live grep the current buffer",
    },
    { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
    { '<leader>f"', "<cmd>Telescope registers<cr>", desc = '[F]ind ["]Registers' },
    -- { "<leader>fg", "<cmd>Telescope git_files<cr>", desc = "[F]ind files ([G]it-files)" },
    -- git
    { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "Search git commits" },
    { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "Search git status" },
  },
}
