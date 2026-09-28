-- Gives lua_ls the nvim runtime + plugin types when editing this config, so
-- `vim` isn't flagged as an undefined global. Only acts on lua buffers.
vim.pack.add({ "https://github.com/folke/lazydev.nvim" })

require("lazydev").setup({
  library = {
    -- load luvit types when the `vim.uv` word is found
    { path = "${3rd}/luv/library", words = { "vim%.uv" } },
  },
})
