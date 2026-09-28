-- Plugins are managed by nvim's built-in vim.pack (:h vim.pack). Each module
-- adds its own plugins with vim.pack.add() and configures them right after.
--
--   :packupdate        fetch updates, review, :write to apply (then :restart)
--   :packdel <name>    remove a plugin after dropping it from its module
--
-- nvim-pack-lock.json is committed: after updating, copy it back into the repo.

local function load(modules)
  for _, module in ipairs(modules) do
    require("phihdn.plugins." .. module)
  end
end

-- Needed for the first screen, or must see the buffer nvim was started with
-- (they hook BufRead/FileType, which fire before any deferred code runs).
load({
  "kanagawa", -- first, so later highlight tweaks land on top of it
  "misc",
  "vim-sleuth",
  "mason", -- puts linters/formatters on PATH before nvim-lint runs
  "oil", -- hijacks `nvim <dir>`
  "nvim-treesitter",
  "nvim-treesitter-textobjects",
  "nvim-lint",
  "markdown",
  "highlight-colors",
})

-- Everything else loads right after startup, like lazy.nvim's VeryLazy:
-- it keeps startup fast and is ready before the first keypress.
vim.schedule(function()
  load({
    "mini",
    "fzf-lua",
    "blink-cmp", -- before lsp, which reads blink's completion capabilities
    "lazydev", -- before lsp, so lua_ls starts with the nvim library
    "lsp", -- vim.lsp.enable() also attaches to already-open buffers
    "conform",
    "git",
    "diffview",
    "trouble",
    "todo",
    "flash",
    "which-key",
    "lualine",
  })
end)
