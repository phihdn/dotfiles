return {
  "ThePrimeagen/harpoon",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    -- harpoon
    vim.keymap.set("n", "<leader>'", "<cmd>lua require('harpoon.mark').add_file()<cr>", { desc = "Add to Harpoon" })
    vim.keymap.set(
      "n",
      "<leader>0",
      "<cmd>lua require('harpoon.ui').toggle_quick_menu()<cr>",
      { desc = "Show Harpoon" }
    )
    vim.keymap.set("n", "<leader>1", "<cmd>lua require('harpoon.ui').nav_file(1)<cr>", { desc = "Harpoon Buffer 1" })
    vim.keymap.set("n", "<leader>2", "<cmd>lua require('harpoon.ui').nav_file(2)<cr>", { desc = "Harpoon Buffer 2" })
    vim.keymap.set("n", "<leader>3", "<cmd>lua require('harpoon.ui').nav_file(3)<cr>", { desc = "Harpoon Buffer 3" })
    vim.keymap.set("n", "<leader>4", "<cmd>lua require('harpoon.ui').nav_file(4)<cr>", { desc = "Harpoon Buffer 4" })
    vim.keymap.set("n", "<leader>5", "<cmd>lua require('harpoon.ui').nav_file(5)<cr>", { desc = "Harpoon Buffer 5" })
    vim.keymap.set("n", "<leader>6", "<cmd>lua require('harpoon.ui').nav_file(6)<cr>", { desc = "Harpoon Buffer 6" })
    vim.keymap.set("n", "<leader>7", "<cmd>lua require('harpoon.ui').nav_file(7)<cr>", { desc = "Harpoon Buffer 7" })
    vim.keymap.set("n", "<leader>8", "<cmd>lua require('harpoon.ui').nav_file(8)<cr>", { desc = "Harpoon Buffer 8" })
    vim.keymap.set("n", "<leader>9", "<cmd>lua require('harpoon.ui').nav_file(9)<cr>", { desc = "Harpoon Buffer 9" })
  end,
}
