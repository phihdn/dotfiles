-- mason installs LSP servers, linters and formatters; setup() puts its bin
-- dir on PATH, so it loads before anything that shells out to those tools
-- (nvim-lint runs on the startup buffer's FileType). The install list lives
-- in plugins/lsp.lua.
vim.pack.add({ "https://github.com/mason-org/mason.nvim" })

require("mason").setup()
