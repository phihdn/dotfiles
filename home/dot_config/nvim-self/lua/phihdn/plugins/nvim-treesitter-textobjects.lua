return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "main",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("nvim-treesitter-textobjects").setup({
      select = {
        -- Automatically jump forward to textobj, similar to targets.vim
        lookahead = true,
        -- Choose the select mode per capture (default is charwise 'v')
        selection_modes = {
          ["@parameter.outer"] = "v", -- charwise
          ["@function.outer"] = "V", -- linewise
          ["@class.outer"] = "<c-v>", -- blockwise
        },
        -- Extend textobjects to include preceding or succeeding whitespace,
        -- acting similarly to the built-in `ap`
        include_surrounding_whitespace = true,
      },
    })

    -- keymaps are set manually on the main branch instead of via a keymaps table
    local select = require("nvim-treesitter-textobjects.select")
    local function map(lhs, query, query_group, desc)
      vim.keymap.set({ "x", "o" }, lhs, function()
        select.select_textobject(query, query_group or "textobjects")
      end, { desc = desc })
    end
    map("af", "@function.outer", nil, "Select outer function")
    map("if", "@function.inner", nil, "Select inner function")
    map("ac", "@class.outer", nil, "Select outer class")
    map("ao", "@comment.outer", nil, "Select outer comment")
    map("ic", "@class.inner", nil, "Select inner part of a class region")
    map("as", "@local.scope", "locals", "Select language scope")
  end,
}
