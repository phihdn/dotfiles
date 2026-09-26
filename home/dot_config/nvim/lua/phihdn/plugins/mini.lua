return {
  {
    "echasnovski/mini.nvim",
    version = false,
    config = function()
      local nmap = function(keys, func, desc)
        if desc then
          desc = desc .. " [Mini]"
        end
        vim.keymap.set("n", keys, func, { desc = desc })
      end

      require("mini.indentscope").setup({
        -- symbol = "▏",
        symbol = "│",
        options = {
          -- indent_at_cursor = false,
          try_as_border = true,
        },
        mappings = {
          goto_top = "[s",
          goto_bottom = "]s",
        },
      })

      require("mini.indentscope").gen_animation.none()
      require("mini.cursorword").setup()
      vim.cmd("hi! MiniCursorwordCurrent guifg=NONE guibg=NONE gui=NONE cterm=NONE") -- disable highlight of the word under the cursor

      -- around/inside textobjects: vif/vaf (function), vic/vac (class),
      -- via (argument), vio (block/loop/conditional), plus counts and
      -- next/last variants (e.g. vinq = inside next quote). Replaces the
      -- manual nvim-treesitter-textobjects select keymaps.
      local ai = require("mini.ai")
      ai.setup({
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
        },
      })

      -- surround on the gs prefix because flash owns plain s:
      -- gsa" (add), gsd" (delete), gsr"' (replace " with ')
      require("mini.surround").setup({
        mappings = {
          add = "gsa",
          delete = "gsd",
          find = "gsf",
          find_left = "gsF",
          highlight = "gsh",
          replace = "gsr",
          update_n_lines = "gsn",
        },
      })

      -- file explorer: popup Miller columns with preview; file ops are
      -- edit-as-text like oil (rename/move/delete lines, then = to sync)
      local MiniFiles = require("mini.files")
      MiniFiles.setup({
        mappings = {
          go_in = "<CR>",
          go_in_plus = "L",
          go_out = "-",
          go_out_plus = "H",
        },
        windows = {
          preview = true,
          width_preview = 40,
        },
      })
      -- <CR> on a file opens it AND closes the explorer; on a directory it
      -- just navigates in (go_in's close_on_file only acts on files)
      vim.api.nvim_create_autocmd("User", {
        pattern = "MiniFilesBufferCreate",
        callback = function(args)
          vim.keymap.set("n", "<CR>", function()
            MiniFiles.go_in({ close_on_file = true })
          end, { buffer = args.data.buf_id, desc = "Go in (close on file)" })
          vim.keymap.set("n", "<Esc>", MiniFiles.close, { buffer = args.data.buf_id, desc = "Close file explorer" })
        end,
      })
      nmap("<leader>ee", function()
        if not MiniFiles.close() then
          MiniFiles.open()
        end
      end, "Toggle file explorer")
      nmap("<leader>ef", function()
        MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
        MiniFiles.reveal_cwd()
      end, "Explore current file's directory")

      -- local miniclue = require("mini.clue")
      -- miniclue.setup({
      --   triggers = {
      --     -- Leader triggers
      --     { mode = "n", keys = "<Leader>" },
      --     { mode = "x", keys = "<Leader>" },
      --
      --     -- No leader keys
      --     { mode = "n", keys = "\\" },
      --     { mode = "n", keys = "z" },
      --     { mode = "x", keys = "z" },
      --     { mode = "n", keys = "<C-w>" },
      --     { mode = "n", keys = "]" },
      --     { mode = "n", keys = "[" },
      --
      --     -- Built-in completion
      --     { mode = "i", keys = "<C-x>" },
      --
      --     -- Marks
      --     { mode = "n", keys = "'" },
      --     { mode = "n", keys = "`" },
      --     { mode = "x", keys = "'" },
      --     { mode = "x", keys = "`" },
      --
      --     -- Registers
      --     { mode = "n", keys = '"' },
      --     { mode = "x", keys = '"' },
      --     { mode = "i", keys = "<C-r>" },
      --     { mode = "c", keys = "<C-r>" },
      --   },
      --
      --   clues = {
      --     -- for built-in keys
      --     miniclue.gen_clues.builtin_completion(),
      --     miniclue.gen_clues.z(),
      --     miniclue.gen_clues.marks(),
      --     miniclue.gen_clues.registers(),
      --     miniclue.gen_clues.windows(),
      --     -- miniclue.gen_clues.g(),
      --   },
      --
      --   window = {
      --     delay = 800,
      --     config = { width = "auto", border = "single" },
      --   },
      -- })
      -- require("mini.statusline").setup()
    end,
  },
}
