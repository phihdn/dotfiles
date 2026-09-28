vim.pack.add({ "https://github.com/lewis6991/gitsigns.nvim" })

require("gitsigns").setup({
  -- hunk keymaps, only in buffers gitsigns tracks: ]h/[h move, <leader>g acts,
  -- ih selects (dih deletes a hunk, vih selects it)
  on_attach = function(bufnr)
    local gs = require("gitsigns")
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end
    -- ]c / [c stay nvim's own in diff mode (diffview); ]h / [h everywhere
    map("n", "]h", function()
      gs.nav_hunk("next")
    end, "Next hunk")
    map("n", "[h", function()
      gs.nav_hunk("prev")
    end, "Previous hunk")
    map("n", "<leader>gp", gs.preview_hunk_inline, "Preview hunk")
    map("n", "<leader>ga", gs.stage_hunk, "Stage/unstage hunk")
    map("n", "<leader>gr", gs.reset_hunk, "Reset hunk")
    map("x", "<leader>ga", function()
      gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, "Stage/unstage selected lines")
    map("x", "<leader>gr", function()
      gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
    end, "Reset selected lines")
    map("n", "<leader>gA", gs.stage_buffer, "Stage buffer")
    map("n", "<leader>gR", gs.reset_buffer, "Reset buffer")
    map("n", "<leader>gb", function()
      gs.blame_line({ full = true })
    end, "Blame line (full commit)")
    map({ "o", "x" }, "ih", gs.select_hunk, "Inside hunk")
  end,
  signs = {
    add = {
      text = "▎",
    },
    change = {
      text = "▎",
    },
    delete = {
      text = "",
    },
    topdelete = {
      text = "",
    },
    changedelete = {
      text = "▎",
    },
  },
  signcolumn = true, -- Toggle with `:Gitsigns toggle_signs`
  numhl = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    follow_files = true,
  },
  auto_attach = true,
  attach_to_untracked = false,
  current_line_blame = true, -- GitLens-style inline blame; <leader>uB toggles it
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = "eol", -- 'eol' | 'overlay' | 'right_align'
    delay = 500, -- ms of cursor rest before the annotation appears
    ignore_whitespace = false,
    virt_text_priority = 100,
  },
  current_line_blame_formatter = "<author>, <author_time:%R> • <summary>",
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000, -- Disable if file is longer than this (in lines)
  preview_config = {
    -- Options passed to nvim_open_win
    border = "single",
    style = "minimal",
    relative = "cursor",
    row = 0,
    col = 1,
  },
})

vim.keymap.set("n", "<leader>uB", "<cmd>Gitsigns toggle_current_line_blame<cr>", { desc = "Toggle inline git blame" })
