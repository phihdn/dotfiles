-- Side-by-side diff review UI, mainly for reviewing AI-generated changesets:
-- <leader>gv opens the working-tree diff with a file panel (Tab/S-Tab cycles
-- files), buffers are real so LSP/edits work inside the diff. Stage/discard
-- verdicts still happen in lazygit — this is the reading surface.
-- Also useful: :DiffviewOpen main...HEAD to review a whole branch.
vim.pack.add({ "https://github.com/sindrets/diffview.nvim" })

vim.keymap.set("n", "<leader>gv", function()
  if require("diffview.lib").get_current_view() then
    vim.cmd("DiffviewClose")
  else
    vim.cmd("DiffviewOpen")
  end
end, { desc = "Diffview (toggle working-tree diff)" })
vim.keymap.set("n", "<leader>gV", "<cmd>DiffviewFileHistory %<cr>", { desc = "Diffview file history (current file)" })
