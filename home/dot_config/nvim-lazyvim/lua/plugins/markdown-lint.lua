-- markdownlint-cli2 only auto-discovers `.markdownlint-cli2.jsonc` by walking
-- up from the current working directory, not from `$HOME` when a project
-- lives elsewhere (e.g. under ~/ws/...). Pass the global config explicitly so
-- rule overrides (see ~/.markdownlint-cli2.jsonc) always apply, regardless of
-- which repo/cwd nvim is opened in.
local global_config = vim.fn.expand("~/.markdownlint-cli2.jsonc")

return {
  {
    "mfussenegger/nvim-lint",
    optional = true,
    opts = {
      linters = {
        ["markdownlint-cli2"] = {
          args = { "--config", global_config, "-" },
        },
      },
    },
  },
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters = {
        ["markdownlint-cli2"] = {
          args = { "--config", global_config, "--fix", "$FILENAME" },
        },
      },
    },
  },
}
