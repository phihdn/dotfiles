vim.pack.add({ "https://github.com/folke/trouble.nvim" })

require("trouble").setup({ focus = true })

local map = function(lhs, cmd, desc)
  vim.keymap.set("n", lhs, "<cmd>Trouble " .. cmd .. "<CR>", { desc = desc })
end
map("<leader>xw", "diagnostics toggle", "Open trouble workspace diagnostics")
map("<leader>xd", "diagnostics toggle filter.buf=0", "Open trouble document diagnostics")
map("<leader>xq", "quickfix toggle", "Open trouble quickfix list")
map("<leader>xl", "loclist toggle", "Open trouble location list")
map("<leader>xt", "todo toggle", "Open todos in trouble")
