# =========================================================
# Plugins
# =========================================================
# A tiny, dependency-free plugin manager: plugins are cloned into
# $ZDOTDIR/plugins on first launch and sourced. Run `zplugin-update` to
# update them. (Replaces zinit.)

ZPLUGINDIR="${ZDOTDIR:-$HOME/.config/zsh}/plugins"

_zplugin_load() {
  local plugin_path="${ZPLUGINDIR}/${2}"
  if [[ ! -d "$plugin_path" ]]; then
    mkdir -p "$ZPLUGINDIR"
    echo "Installing ${2}..."
    git clone --depth=1 "https://github.com/${1}/${2}" "$plugin_path" \
      || { echo "ERROR: failed to install ${2}" >&2; return 1; }
  fi
  source "${plugin_path}/${2}.plugin.zsh"
}

zplugin-update() {
  local dir
  for dir in "${ZPLUGINDIR}"/*/; do
    echo "Updating ${dir:t}..."
    git -C "$dir" pull --ff-only
  done
}

_zplugin_load zsh-users zsh-autosuggestions
_zplugin_load zsh-users zsh-history-substring-search

# Initialize zsh-vi-mode at source time instead of its default deferred
# (first-prompt) init. Deferred init makes zvm re-wrap ZLE widgets *after*
# fast-syntax-highlighting already wrapped them, which causes recursive widget
# calls ("_zsh_highlight_call_widget: maximum nested function level reached")
# when pressing Up (history-substring-search) or Esc (vi mode switch). Sourcing
# mode lets the highlighter wrap last, which is the order it expects.
ZVM_INIT_MODE=sourcing
_zplugin_load jeffreytse zsh-vi-mode
_zplugin_load zdharma-continuum fast-syntax-highlighting
