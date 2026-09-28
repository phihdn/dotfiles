-- markdownlint-cli2 only auto-discovers `.markdownlint-cli2.jsonc` by walking
-- up from the current working directory, not from `$HOME` when a project
-- lives elsewhere (e.g. under ~/ws/...). Pass the global config explicitly so
-- rule overrides (see ~/.markdownlint-cli2.jsonc) always apply, regardless of
-- which repo/cwd nvim is opened in.
vim.pack.add({ "https://github.com/mfussenegger/nvim-lint" })

local lint = require("lint")

lint.linters_by_ft = {
  markdown = { "markdownlint-cli2" },
}

lint.linters["markdownlint-cli2"].args = {
  "--config",
  vim.fn.expand("~/.markdownlint-cli2.jsonc"),
  "-",
}

vim.api.nvim_create_autocmd({ "FileType", "BufWritePost", "InsertLeave" }, {
  group = vim.api.nvim_create_augroup("phihdn-nvim-lint", { clear = true }),
  callback = function(args)
    if vim.b[args.buf].bigfile then
      return
    end
    require("lint").try_lint(nil, { ignore_errors = true })
  end,
})
