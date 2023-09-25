return {
  "goolord/alpha-nvim",
  event = "VimEnter",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")
    local logo = [[
      ██████╗ ██╗  ██╗██╗██╗  ██╗██████╗ ███╗   ██╗
      ██╔══██╗██║  ██║██║██║  ██║██╔══██╗████╗  ██║ 
      ██████╔╝███████║██║███████║██║  ██║██╔██╗ ██║
      ██╔═══╝ ██╔══██║██║██╔══██║██║  ██║██║╚██╗██║
      ██║     ██║  ██║██║██║  ██║██████╔╝██║ ╚████║
      ╚═╝     ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═══╝
    ]]
    dashboard.section.header.val = vim.split(logo, "\n")
    -- Set header
    --[[ dashboard.section.header.val = {
      "                                                ",
      "  ██████╗ ██╗  ██╗██╗██╗  ██╗██████╗ ███╗   ██╗ ",
      "  ██╔══██╗██║  ██║██║██║  ██║██╔══██╗████╗  ██║ ",
      "  ██████╔╝███████║██║███████║██║  ██║██╔██╗ ██║ ",
      "  ██╔═══╝ ██╔══██║██║██╔══██║██║  ██║██║╚██╗██║ ",
      "  ██║     ██║  ██║██║██║  ██║██████╔╝██║ ╚████║ ",
      "  ╚═╝     ╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═════╝ ╚═╝  ╚═══╝ ",
      "                                                ",
    } ]]

    -- Set menu
    dashboard.section.buttons.val = {
      dashboard.button("e", " > New File", "<cmd>ene<CR>"),
      dashboard.button("SPC ee", " > Toggle file explorer", "<cmd>NvimTreeToggle<CR>"),
      dashboard.button("SPC ff", "󰱼 > Find File", "<cmd>Telescope find_files<CR>"),
      dashboard.button("SPC fs", " > Find Word", "<cmd>Telescope live_grep<CR>"),
      dashboard.button("SPC wr", "󰁯 > Restore Session For Current Directory", "<cmd>SessionRestore<CR>"),
      dashboard.button("q", " > Quit NVIM", "<cmd>qa<CR>"),
    }

    dashboard.section.footer.val = require("alpha.fortune")
    dashboard.section.header.opts.hl = "Function"
    dashboard.section.footer.opts.hl = "Function"

    -- Send config to alpha
    alpha.setup(dashboard.opts)

    -- Disable folding on alpha buffer
    vim.cmd([[autocmd FileType alpha setlocal nofoldenable]])
  end,
}