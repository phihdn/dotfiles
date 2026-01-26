# Fish Shell Configuration
# Clean, fast, with lazy loading and LLM-agent compatibility

# Disable greeting
set -U fish_greeting

# Environment
set -gx SHELL /opt/homebrew/bin/fish
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx LANG en_US.UTF-8
set -gx LC_ALL en_US.UTF-8
set -gx XDG_CONFIG_HOME "$HOME/.config"
set -gx K9S_CONFIG_DIR "$XDG_CONFIG_HOME/k9s"

# FZF defaults
set -gx FZF_DEFAULT_COMMAND "fd -H -E '.git'"

# 1Password SSH agent
set -gx SSH_AUTH_SOCK ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

# Detect LLM/Agent mode - use simple prompt for automation
if set -q CURSOR_AGENT; or set -q CLAUDE_CODE; or set -q TERM_PROGRAM_VERSION; and string match -q "*agent*" "$TERM_PROGRAM"
    # Simple prompt for LLM agents
    function fish_prompt
        echo '$ '
    end
    function fish_right_prompt; end
else if status is-interactive
    # Starship prompt for interactive sessions
    if type -q starship
        starship init fish | source
    end
end

# Zoxide (smart cd)
if status is-interactive; and type -q zoxide
    zoxide init fish | source
end

# Vi key bindings
set -g fish_key_bindings fish_vi_key_bindings
