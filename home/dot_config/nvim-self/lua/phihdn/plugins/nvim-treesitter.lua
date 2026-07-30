return {
  {
    "nvim-treesitter/nvim-treesitter",
    -- the archived master branch predates the query API removal in nvim 0.13-dev;
    -- main is the supported rewrite for nightly builds
    branch = "main",
    lazy = false,
    build = ":TSUpdate",
    config = function()
      -- language parsers to install (main branch has no ensure_installed option)
      require("nvim-treesitter").install({
        "json",
        "javascript",
        "typescript",
        "tsx",
        "yaml",
        "html",
        "css",
        "markdown",
        "markdown_inline",
        "bash",
        "lua",
        "vim",
        "dockerfile",
        "gitignore",
        "query",
        "vimdoc",
        "c",
        "go",
        "gomod",
        "gowork",
        "gosum",
        "terraform",
        "proto",
        "regex",
      })

      -- main branch enables highlighting/indentation per buffer instead of globally;
      -- pcall skips filetypes whose parser isn't installed
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("phihdn.treesitter", { clear = true }),
        callback = function(args)
          if pcall(vim.treesitter.start, args.buf) then
            vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
          end
        end,
      })
    end,
  },
  {
    -- autotag no longer hooks into nvim-treesitter's setup; it configures itself
    "windwp/nvim-ts-autotag",
    event = { "BufReadPre", "BufNewFile" },
    opts = {},
  },
}
