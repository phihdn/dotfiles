vim.pack.add({ "https://github.com/folke/which-key.nvim" })

require("which-key").setup({
  preset = "helix",
  -- v3 spec: group labels for the leader prefixes used across this config
  spec = {
    { "<leader>b", group = "buffer" },
    { "<leader>c", group = "code" },
    { "<leader>e", group = "explorer" },
    { "<leader>f", group = "find" },
    { "<leader>g", group = "git" },
    { "<leader>s", group = "split" },
    { "<leader>u", group = "ui/toggles" },
    { "<leader>x", group = "diagnostics" },
    { "<leader>y", group = "yank to clipboard" },
    { "gs", group = "surround" },
  },
})

vim.keymap.set("n", "<leader>?", function()
  require("which-key").show({ global = false })
end, { desc = "Buffer-local keymaps" })
