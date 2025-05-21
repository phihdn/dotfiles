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

      -- local MiniFiles = require("mini.files")
      -- MiniFiles.setup({
      --   mappings = {
      --     go_in = "<CR>", -- Map both Enter and L to enter directories or open files
      --     go_in_plus = "L",
      --     go_out = "-",
      --     go_out_plus = "H",
      --   },
      -- })
      -- vim.keymap.set("n", "<leader>ee", "<cmd>lua MiniFiles.open()<CR>", { desc = "Toggle mini file explorer" }) -- toggle file explorer
      -- vim.keymap.set("n", "<leader>ef", function()
      --   MiniFiles.open(vim.api.nvim_buf_get_name(0), false)
      --   MiniFiles.reveal_cwd()
      -- end, { desc = "Toggle into currently opened file" })

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
