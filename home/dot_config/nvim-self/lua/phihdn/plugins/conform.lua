return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
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
        -- Find git root directory
        local git_root = nil
        local current_dir = vim.fn.fnamemodify(bufname, ":p:h")

        -- Function to find git root
        local function find_git_root(dir)
          local git_dir = dir .. "/.git"
          if vim.fn.isdirectory(git_dir) == 1 then
            return dir
          end

          -- Go up one directory
          local parent = vim.fn.fnamemodify(dir, ":h")
          if parent == dir then
            -- We've reached the filesystem root
            return nil
          end

          return find_git_root(parent)
        end

        git_root = find_git_root(current_dir)

        -- Check for .prettierrc.json in git root if we found a git root
        if git_root then
          local prettier_path = git_root .. "/.prettierrc.json"
          if vim.fn.filereadable(prettier_path) == 1 then
            return { timeout_ms = 1000, lsp_fallback = true }
          end
        end

        -- Don't format JS/TS if no .prettierrc.json found in git root
        return
      end

      -- For all other filetypes
      return { timeout_ms = 1000, lsp_fallback = true }
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
