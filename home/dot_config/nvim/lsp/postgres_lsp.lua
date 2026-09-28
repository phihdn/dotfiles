-- Server defaults adapted from nvim-lspconfig (lsp/postgres_lsp.lua @ a9bb4d5f); read by
-- nvim's built-in vim.lsp.config() from the runtimepath.
return {
  cmd = { "postgres-language-server", "lsp-proxy" },
  filetypes = {
    "sql",
  },
  root_markers = { "postgres-language-server.jsonc" },
  workspace_required = true,
}
