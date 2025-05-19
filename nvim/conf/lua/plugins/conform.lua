return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- Disable autoformat on certain filetypes
      local ignore_filetypes = { "typescript", "javascript" }
      if vim.tbl_contains(ignore_filetypes, vim.bo[bufnr].filetype) then
        return
      end
      -- Disable with a global or buffer-local variable
      if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
        return
      end
      -- Disable autoformat for files in a certain path
      local bufname = vim.api.nvim_buf_get_name(bufnr)
      if bufname:match("/node_modules/") then
        return
      end
      -- ...additional logic...
      return { timeout_ms = 1000, lsp_fallback = true }
    end,
    formatters_by_ft = {
      graphql = { "prettier" },
      lua = { "stylua", stop_after_first = true },
      python = { "black" },
      javascript = { "prettier", stop_after_first = true },
      javascriptreact = { "prettier", stop_after_first = true },
      typescript = { "prettier", stop_after_first = true },
      typescriptreact = { "prettier", stop_after_first = true },
      go = { "gofumpt", "golines", "goimports-reviser" },
      c = { "clang_format" },
      cpp = { "clang_format" },
      yaml = { "yamlfmt" },
      -- templ = { "prettier" },
      html = { "prettier" },
      json = { "prettier" },
      markdown = { "prettier" },
      -- sql = { "sqlfmt" },
      css = { "prettier", stop_after_first = true },
    },
  },
  keys = {
    {
      "<leader>cf",
      function()
        require("conform").format({
          lsp_fallback = true,
          async = true,
        })
      end,
      mode = "",
      desc = "[C]ode [F]ormat buffer",
    },
  },
}
