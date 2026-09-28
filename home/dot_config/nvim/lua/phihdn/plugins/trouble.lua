vim.pack.add({ "https://github.com/folke/trouble.nvim" })

require("trouble").setup({ focus = true })

local map = function(lhs, cmd, desc)
  vim.keymap.set("n", lhs, "<cmd>Trouble " .. cmd .. "<CR>", { desc = desc })
end
map("<leader>xw", "diagnostics toggle", "Workspace diagnostics (trouble)")
map("<leader>xd", "diagnostics toggle filter.buf=0", "Buffer diagnostics (trouble)")
map("<leader>xq", "quickfix toggle", "Quickfix list (trouble)")
map("<leader>xl", "loclist toggle", "Location list (trouble)")
map("<leader>xt", "todo toggle", "Todo comments (trouble)")
