-- GitLens-style inline blame: show commit author/time/message as virtual
-- text at the end of the cursor line (gitsigns ships with LazyVim, this
-- just turns the feature on). <leader>uB toggles it when it gets noisy.
return {
  "lewis6991/gitsigns.nvim",
  opts = {
    current_line_blame = true,
    current_line_blame_opts = {
      virt_text_pos = "eol",
      delay = 500, -- ms of cursor rest before the annotation appears
    },
    current_line_blame_formatter = "<author>, <author_time:%R> • <summary>",
  },
  keys = {
    { "<leader>uB", "<cmd>Gitsigns toggle_current_line_blame<cr>", desc = "Toggle inline git blame" },
  },
}
