-- Counterpart to the vim-aware C-hjkl bindings in tmux.conf: lets C-hjkl move
-- seamlessly between nvim splits and tmux panes (overrides LazyVim's defaults)
return {
  {
    "christoomey/vim-tmux-navigator",
    cmd = {
      "TmuxNavigateLeft",
      "TmuxNavigateDown",
      "TmuxNavigateUp",
      "TmuxNavigateRight",
      "TmuxNavigatePrevious",
    },
    keys = {
      { "<C-h>", "<cmd>TmuxNavigateLeft<cr>", desc = "Go to left window/pane" },
      { "<C-j>", "<cmd>TmuxNavigateDown<cr>", desc = "Go to lower window/pane" },
      { "<C-k>", "<cmd>TmuxNavigateUp<cr>", desc = "Go to upper window/pane" },
      { "<C-l>", "<cmd>TmuxNavigateRight<cr>", desc = "Go to right window/pane" },
      { "<C-\\>", "<cmd>TmuxNavigatePrevious<cr>", desc = "Go to previous pane" },
    },
  },
  -- Snacks picker binds C-j/C-k window-locally to list_down/list_up, shadowing
  -- the navigator maps above while a picker is open. C-n/C-p provide the same
  -- list movement, so reclaim C-j/C-k for tmux pane switching. Going through
  -- tmux directly (not TmuxNavigate*, which does wincmd first) leaves the
  -- picker open and focused, so tmux-ing back into nvim resumes it as-is.
  -- Outside tmux they fall back to normal list movement.
  {
    "folke/snacks.nvim",
    opts = {
      picker = {
        actions = {
          tmux_navigate_down = function(picker)
            if vim.env.TMUX then
              vim.system({ "tmux", "select-pane", "-D" })
            else
              picker.list:move(1)
            end
          end,
          tmux_navigate_up = function(picker)
            if vim.env.TMUX then
              vim.system({ "tmux", "select-pane", "-U" })
            else
              picker.list:move(-1)
            end
          end,
        },
        win = {
          input = {
            keys = {
              ["<c-j>"] = { "tmux_navigate_down", mode = { "i", "n" } },
              ["<c-k>"] = { "tmux_navigate_up", mode = { "i", "n" } },
            },
          },
          list = {
            keys = {
              ["<c-j>"] = "tmux_navigate_down",
              ["<c-k>"] = "tmux_navigate_up",
            },
          },
        },
      },
    },
  },
}
