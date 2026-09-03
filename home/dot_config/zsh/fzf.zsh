# =========================================================
# fzf
# =========================================================

export FZF_DEFAULT_COMMAND='fd --type f --hidden --strip-cwd-prefix'  # strip-cwd-prefix removes the leading ./ from results

# Ctrl-T uses fd
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

# UI
# Catppuccin Mocha — https://github.com/catppuccin/fzf
export FZF_DEFAULT_OPTS='
  --height=60%
  --layout=reverse
  --border=rounded
  --prompt="  "
  --preview-window=right:65%:wrap:border-left
  --color=fg:#cdd6f4,bg:#1e1e2e,hl:#f9e2af
  --color=fg+:#cdd6f4,bg+:#313244,hl+:#f9e2af
  --color=info:#89b4fa,prompt:#f38ba8,pointer:#f38ba8
  --color=marker:#a6e3a1,spinner:#94e2d5,header:#6c7086
  --color=border:#313244,gutter:#1e1e2e
'

export _FZF_PREVIEW_CMD='bat --color=always --style=plain,numbers --line-range=:500 {}'
export FZF_CTRL_T_OPTS="--preview '$_FZF_PREVIEW_CMD'"

# Ctrl+F: file picker excluding hidden files
_fzf_file_no_hidden() {
  local cmd result
  cmd="${FZF_DEFAULT_COMMAND/--hidden /}"
  result=$(eval "${cmd:-find . -type f}" | fzf --preview "$_FZF_PREVIEW_CMD") \
    && LBUFFER+="$result"  # LBUFFER is the text left of the cursor
  zle reset-prompt
}
zle -N _fzf_file_no_hidden