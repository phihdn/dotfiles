vim.pack.add({ "https://github.com/ibhagwan/fzf-lua" })

local fzf = require("fzf-lua")
fzf.setup({
  files = { cwd_prompt = false },
  grep = {
    rg_opts = "--column --line-number --no-heading --color=always --smart-case --hidden --glob=!.git/ --max-columns=4096 -e",
  },
  -- vim-tmux-navigator forwards <C-j>/<C-k> straight to the fzf process
  -- while focused in the picker (it detects ft == "fzf"), so they move the
  -- list instead of switching to a tmux pane/terminal below. Reclaim them
  -- for tmux pane navigation; ctrl-n/ctrl-p still move the list.
  keymap = {
    fzf = {
      ["ctrl-j"] = vim.env.TMUX and "execute-silent:tmux select-pane -D" or "down",
      ["ctrl-k"] = vim.env.TMUX and "execute-silent:tmux select-pane -U" or "up",
    },
  },
})
-- replace vim.ui.select (code actions, etc.) with an fzf-lua picker
fzf.register_ui_select()

local map = function(lhs, picker, desc)
  vim.keymap.set("n", lhs, picker, { desc = desc })
end

map("<leader>ff", fzf.files, "[F]ind [F]iles in project directory")
map("<leader>fg", fzf.live_grep, "[F]ind by [G]repping in project directory")
map("<leader>fn", function()
  fzf.files({ cwd = vim.fn.stdpath("config") })
end, "[F]ind in [N]eovim configuration")
map("<leader>fh", fzf.helptags, "[F]ind [H]elp")
map("<leader>fk", fzf.keymaps, "[F]ind [K]eymaps")
map("<leader>fb", fzf.buffers, "[F]ind [B]uffers")
map("<leader>fz", fzf.builtin, "[F]ind f[z]f-lua builtin pickers")
map("<leader>fw", fzf.grep_cword, "[F]ind current [W]ord")
map("<leader>fW", fzf.grep_cWORD, "[F]ind current [W]ORD")
map("<leader>fd", fzf.diagnostics_document, "[F]ind buffer [D]iagnostics")
map("<leader>fD", fzf.diagnostics_workspace, "[F]ind workspace [D]iagnostics")
map("<leader>fr", fzf.resume, "[F]ind [R]esume")
map("<leader>fo", fzf.oldfiles, "[F]ind [O]ld Files")
map('<leader>f"', fzf.registers, '[F]ind ["]Registers')
map("<leader>:", fzf.command_history, "Command History")
map("<leader><leader>", fzf.buffers, "[ ] Find existing buffers")
map("<leader>/", fzf.lgrep_curbuf, "[/] Live grep the current buffer")
map("<leader>gc", fzf.git_commits, "Search [g]it [c]ommits")
map("<leader>gs", fzf.git_status, "Search [g]it [s]tatus")
