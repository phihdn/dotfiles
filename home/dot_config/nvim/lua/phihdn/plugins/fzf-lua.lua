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

map("<leader>ff", fzf.files, "Files")
map("<leader>fg", fzf.live_grep, "Grep project")
map("<leader>fn", function()
  fzf.files({ cwd = vim.fn.stdpath("config") })
end, "Neovim config files")
map("<leader>fh", fzf.helptags, "Help tags")
map("<leader>fk", fzf.keymaps, "Keymaps")
map("<leader>fb", fzf.buffers, "Buffers")
map("<leader>fz", fzf.builtin, "All pickers (fzf-lua)")
map("<leader>fw", fzf.grep_cword, "Grep word under cursor")
map("<leader>fW", fzf.grep_cWORD, "Grep WORD under cursor")
map("<leader>fd", fzf.diagnostics_document, "Buffer diagnostics")
map("<leader>fD", fzf.diagnostics_workspace, "Workspace diagnostics")
map("<leader>fr", fzf.resume, "Resume last picker")
map("<leader>fo", fzf.oldfiles, "Recent files")
map('<leader>f"', fzf.registers, "Registers")
map("<leader>:", fzf.command_history, "Command history")
map("<leader><leader>", fzf.buffers, "Buffers")
map("<leader>/", fzf.lgrep_curbuf, "Grep current buffer")
map("<leader>gc", fzf.git_commits, "Commits")
map("<leader>gs", fzf.git_status, "Changed files")
