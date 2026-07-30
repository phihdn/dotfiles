-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`

-- Highlight when yanking (copying) text
--  Try it with `yap` in normal mode
--  See `:help vim.highlight.on_yank()`
vim.api.nvim_create_autocmd("TextYankPost", {
  desc = "Highlight when yanking (copying) text",
  group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_user_command("FormatDisable", function(args)
  if args.bang then
    -- FormatDisable! will disable formatting just for this buffer
    vim.b.disable_autoformat = true
  else
    vim.g.disable_autoformat = true
  end
end, {
  desc = "Disable autoformat-on-save",
  bang = true,
})

vim.api.nvim_create_user_command("FormatEnable", function()
  vim.b.disable_autoformat = false
  vim.g.disable_autoformat = false
end, {
  desc = "Re-enable autoformat-on-save",
})

-- Big files: flag buffers over 1.5MB so expensive per-buffer features
-- (treesitter, lint, format-on-save, folds) can opt out and opening stays instant
local bigfile_group = vim.api.nvim_create_augroup("phihdn-bigfile", { clear = true })
vim.api.nvim_create_autocmd("BufReadPre", {
  desc = "Flag big files",
  group = bigfile_group,
  callback = function(args)
    local stats = vim.uv.fs_stat(vim.api.nvim_buf_get_name(args.buf))
    if stats and stats.size > 1.5 * 1024 * 1024 then
      vim.b[args.buf].bigfile = true
      vim.b[args.buf].disable_autoformat = true -- conform format-on-save opt-out
      vim.bo[args.buf].swapfile = false
    end
  end,
})
vim.api.nvim_create_autocmd("FileType", {
  desc = "Disable expr folds and treesitter in big files",
  group = bigfile_group,
  callback = function(args)
    if vim.b[args.buf].bigfile then
      -- core ftplugins (markdown, lua, ...) start treesitter themselves,
      -- bypassing this config's guarded FileType hook — stop it again
      vim.treesitter.stop(args.buf)
      vim.api.nvim_buf_call(args.buf, function()
        vim.opt_local.foldmethod = "manual"
      end)
    end
  end,
})
