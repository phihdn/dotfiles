-- the archived master branch predates the query API removal in nvim 0.13-dev;
-- main is the supported rewrite for nightly builds
vim.pack.add({
  { src = "https://github.com/nvim-treesitter/nvim-treesitter", version = "main" },
  -- autotag no longer hooks into nvim-treesitter's setup; it configures itself
  "https://github.com/windwp/nvim-ts-autotag",
})

-- keep compiled parsers in step with the plugin's queries after :packupdate
vim.api.nvim_create_autocmd("PackChanged", {
  desc = "Update treesitter parsers after nvim-treesitter updates",
  group = vim.api.nvim_create_augroup("phihdn-treesitter-update", { clear = true }),
  callback = function(ev)
    if ev.data.spec.name == "nvim-treesitter" and ev.data.kind == "update" then
      if not ev.data.active then
        vim.cmd.packadd("nvim-treesitter")
      end
      vim.cmd("TSUpdate")
    end
  end,
})

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
  "python",
  "sql",
  "toml",
  "diff",
  "gitcommit",
})

-- main branch enables highlighting/indentation per buffer instead of globally;
-- pcall skips filetypes whose parser isn't installed
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("phihdn.treesitter", { clear = true }),
  callback = function(args)
    if vim.b[args.buf].bigfile then
      return
    end
    if pcall(vim.treesitter.start, args.buf) then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

require("nvim-ts-autotag").setup()
