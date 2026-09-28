-- Gives lua_ls the nvim runtime + plugin types when editing this config, so
-- `vim` isn't flagged as an undefined global. Loads only for lua buffers.
return {
  "folke/lazydev.nvim",
  ft = "lua",
  opts = {
    library = {
      -- load luvit types when the `vim.uv` word is found
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
    },
  },
}
