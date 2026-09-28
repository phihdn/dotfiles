-- Server defaults adapted from nvim-lspconfig (lsp/marksman.lua @ a9bb4d5f); read by
-- nvim's built-in vim.lsp.config() from the runtimepath.
return {
  cmd = { "marksman", "server" },
  filetypes = { "markdown", "markdown.mdx" },
  root_markers = { ".marksman.toml", ".git" },
}
