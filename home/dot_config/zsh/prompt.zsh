# =========================================================
# Prompt
# =========================================================

# Prevent Python virtualenv from prefixing the prompt (starship shows it)
export VIRTUAL_ENV_DISABLE_PROMPT=1
FUNCNEST=100

if [[ -n "$CURSOR_AGENT" ]]; then
  # Minimal prompt when running inside Cursor Agent
  export PS1='$ '
else
  eval "$(starship init zsh)"
fi
