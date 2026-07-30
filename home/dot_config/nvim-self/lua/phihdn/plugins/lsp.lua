return {
  -- nvim 0.11+ native LSP: nvim-lspconfig is data-only here — it ships the
  -- lsp/<server>.lua defaults (cmd, filetypes, root markers) that
  -- vim.lsp.config() reads from the runtimepath. No require("lspconfig").
  "neovim/nvim-lspconfig",
  dependencies = {
    { "mason-org/mason.nvim", opts = {} },
    -- installs the binaries listed below into mason's bin dir
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- LSP progress messages in the corner
    { "j-hui/fidget.nvim", opts = {} },
  },
  config = function()
    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("phihdn-lsp-attach", { clear = true }),
      callback = function(event)
        local map = function(keys, func, desc, mode)
          vim.keymap.set(mode or "n", keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
        end
        -- defer the fzf-lua require to first keypress so LspAttach doesn't
        -- force-load the picker plugin
        local fzf = function(picker)
          return function()
            require("fzf-lua")[picker]()
          end
        end

        -- gd/gD plus the nvim 0.11 builtin gr*/gO lhs, rebound to fzf-lua
        -- pickers for a better UI than the default quickfix. grn (rename) and
        -- gra (code action) stay on the builtin implementations.
        map("gd", fzf("lsp_definitions"), "[G]oto [D]efinition")
        map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
        map("grr", fzf("lsp_references"), "[G]oto [R]eferences")
        map("gri", fzf("lsp_implementations"), "[G]oto [I]mplementation")
        map("grt", fzf("lsp_typedefs"), "[G]oto [T]ype definition")
        map("gO", fzf("lsp_document_symbols"), "Document Symbols")
        map("gW", fzf("lsp_live_workspace_symbols"), "Workspace Symbols")

        local client = vim.lsp.get_client_by_id(event.data.client_id)

        -- highlight other references of the symbol under the cursor while it rests
        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight, event.buf) then
          local highlight_augroup = vim.api.nvim_create_augroup("phihdn-lsp-highlight", { clear = false })
          vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.document_highlight,
          })
          vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
            buffer = event.buf,
            group = highlight_augroup,
            callback = vim.lsp.buf.clear_references,
          })
          vim.api.nvim_create_autocmd("LspDetach", {
            group = vim.api.nvim_create_augroup("phihdn-lsp-detach", { clear = true }),
            callback = function(event2)
              vim.lsp.buf.clear_references()
              vim.api.nvim_clear_autocmds({ group = "phihdn-lsp-highlight", buffer = event2.buf })
            end,
          })
        end

        if client and client:supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf) then
          map("<leader>uh", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
          end, "Toggle inlay [h]ints")
        end
      end,
    })

    vim.diagnostic.config({
      severity_sort = true,
      float = { border = "rounded", source = "if_many" },
      underline = { severity = vim.diagnostic.severity.ERROR },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "󰅚 ",
          [vim.diagnostic.severity.WARN] = "󰀪 ",
          [vim.diagnostic.severity.INFO] = "󰋽 ",
          [vim.diagnostic.severity.HINT] = "󰌶 ",
        },
      },
      -- short one-liners on other lines, full multi-line panel under the cursor line
      virtual_text = { source = "if_many", spacing = 2, current_line = false },
      virtual_lines = { current_line = true },
    })

    -- broadcast blink.cmp's extra completion capabilities to every server
    vim.lsp.config("*", { capabilities = require("blink.cmp").get_lsp_capabilities() })

    vim.lsp.config("yamlls", {
      settings = {
        yaml = {
          keyOrdering = false,
          format = { enable = true },
        },
      },
    })

    -- servers by nvim-lspconfig name; mason package names differ (list below)
    vim.lsp.enable({
      "bashls",
      "basedpyright",
      "gopls",
      "lua_ls",
      "marksman",
      "postgres_lsp",
      "ts_ls",
      "yamlls",
    })

    require("mason-tool-installer").setup({
      ensure_installed = {
        -- language servers (mason package names)
        "bash-language-server",
        "basedpyright",
        "gopls",
        "lua-language-server",
        "marksman",
        "postgres-language-server",
        "typescript-language-server",
        "yaml-language-server",
        -- linters (used by nvim-lint)
        "markdownlint-cli2",
        -- formatters (used by conform.nvim)
        "stylua",
        "prettierd",
        "prettier",
        "gofumpt",
        "golines",
        "goimports-reviser",
        "sleek",
      },
    })
  end,
}
