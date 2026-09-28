vim.pack.add({ "https://github.com/stevearc/conform.nvim" })

require("conform").setup({
  notify_on_error = false,
  format_on_save = function(bufnr)
    local bufname = vim.api.nvim_buf_get_name(bufnr)
    local filetype = vim.bo[bufnr].filetype

    -- Disable autoformat if global or buffer-local variable is set
    if vim.g.disable_autoformat or vim.b[bufnr].disable_autoformat then
      return
    end

    -- Disable autoformat for files in node_modules
    if bufname:match("/node_modules/") then
      return
    end

    -- For JavaScript and TypeScript files, check for .prettierrc.json in git root
    if
      filetype == "javascript"
      or filetype == "typescript"
      or filetype == "javascriptreact"
      or filetype == "typescriptreact"
    then
      local git_root = vim.fs.root(bufnr, ".git")
      if git_root and vim.uv.fs_stat(git_root .. "/.prettierrc.json") then
        return { timeout_ms = 1000, lsp_format = "fallback" }
      end

      -- Don't format JS/TS if no .prettierrc.json found in git root
      return
    end

    -- For all other filetypes
    return { timeout_ms = 1000, lsp_format = "fallback" }
  end,
  formatters_by_ft = {
    graphql = { "prettier" },
    lua = { "stylua", stop_after_first = true },
    python = { "black" },
    javascript = { "prettierd", stop_after_first = true },
    javascriptreact = { "prettierd", stop_after_first = true },
    typescript = { "prettierd", stop_after_first = true },
    typescriptreact = { "prettierd", stop_after_first = true },
    go = { "gofumpt", "golines", "goimports-reviser" },
    c = { "clang_format" },
    cpp = { "clang_format" },
    yaml = { "prettierd" },
    -- templ = { "prettier" },
    html = { "prettierd" },
    json = { "prettierd" },
    markdown = { "prettierd" },
    sql = { "sleek" },
    css = { "prettierd", stop_after_first = true },
  },
})

vim.keymap.set("", "<leader>cf", function()
  require("conform").format({ lsp_format = "fallback", async = true })
end, { desc = "[C]ode [F]ormat buffer" })
