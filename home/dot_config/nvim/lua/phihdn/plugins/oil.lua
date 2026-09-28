vim.pack.add({
  "https://github.com/stevearc/oil.nvim",
  "https://github.com/nvim-tree/nvim-web-devicons",
  -- git status of each entry in the sign column
  "https://github.com/refractalize/oil-git-status.nvim",
})

CustomOilBar = function()
  local path = vim.fn.expand("%")
  path = path:gsub("oil://", "")

  return "  " .. vim.fn.fnamemodify(path, ":.")
end

require("oil").setup({
  columns = { "icon" },
  keymaps = {
    ["<C-h>"] = false,
    ["<C-l>"] = false,
    ["<C-k>"] = false,
    ["<C-j>"] = false,
    ["<C-c>"] = false, -- prevent from closing Oil as <C-c> is esc key
    ["<M-h>"] = "actions.select_split",
    ["q"] = "actions.close",
    ["<Esc>"] = "actions.close",
  },
  win_options = {
    winbar = "%{v:lua.CustomOilBar()}",
    signcolumn = "yes:2", -- oil-git-status: staged + unstaged columns
  },
  view_options = {
    show_hidden = true,
    is_always_hidden = function(name, _)
      local folder_skip = { "dev-tools.locks", "dune.lock", "_build" }
      return vim.tbl_contains(folder_skip, name)
    end,
  },
})

require("oil-git-status").setup({ show_ignored = false })

-- Open parent directory in current window
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })

-- Open parent directory in floating window
vim.keymap.set("n", "<leader>-", require("oil").toggle_float, { desc = "Toggle Oil float" })

vim.api.nvim_create_autocmd("FileType", {
  pattern = "oil", -- Adjust if Oil uses a specific file type identifier
  callback = function()
    vim.opt_local.cursorline = true
  end,
})
