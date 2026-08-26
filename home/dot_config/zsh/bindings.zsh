# =========================================================
# Keybindings
# =========================================================

# Cursor shape per vi mode
ZVM_INSERT_MODE_CURSOR=$ZVM_CURSOR_BEAM
ZVM_NORMAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK
ZVM_VISUAL_MODE_CURSOR=$ZVM_CURSOR_BLOCK

# Disable command-mode line highlight
ZVM_VI_HIGHLIGHT_BACKGROUND=none
ZVM_VI_HIGHLIGHT_FOREGROUND=none
ZVM_VI_HIGHLIGHT_EXTRASTYLE=none

# Don't render pasted text in reverse video: the standout region hides the
# block cursor, which makes the cursor look stuck until the next keystroke
# clears the highlight.
zle_highlight=('paste:none')

# zsh-vi-mode resets all bindings on init, so custom bindings must be
# registered via this hook to survive.
zvm_after_init() {
  # Ctrl+Right / Ctrl+Left -> move by word
  bindkey '^[[1;5C' forward-word
  bindkey '^[[1;5D' backward-word

  # zsh-vi-mode's init reset leaves the normal-mode arrow variants (^[[C/^[[D)
  # unbound in insert mode, keeping only the application-mode ones (^[OC/^[OD).
  # Right after a bracketed paste the terminal emits the unbound variant, which
  # falls through to zvm's ESC reader and lands in vi-normal mode -- the cursor
  # freezes and stray [ / D keys can corrupt the pasted command. Bind them.
  bindkey '^[[C' vi-forward-char
  bindkey '^[[D' vi-backward-char

  # Ctrl+F -> fzf file picker (no hidden files)
  bindkey '^F' _fzf_file_no_hidden

  # Re-bind fzf widgets clobbered by zsh-vi-mode's init reset
  bindkey '^R' fzf-history-widget  # Ctrl+R -> fuzzy history search
  bindkey '^T' fzf-file-widget     # Ctrl+T -> fuzzy file insert

  # Ctrl+\ -> toggle autosuggestions
  bindkey '^\' autosuggest-toggle

  # Up/Down -> substring history search
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
}
