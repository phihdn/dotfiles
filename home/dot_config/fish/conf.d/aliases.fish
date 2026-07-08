# Aliases - for commands that need arguments or complex behavior

alias v nvim
alias grep "grep --color"
alias please sudo

# GNU tools over BSD
alias sed gsed
alias awk gawk

# Claude Code — multiple accounts (isolated CLAUDE_CONFIG_DIR per account).
# fish has no `VAR=value cmd` prefix, so use env. Run `/login` once per alias.
alias claude-work "env CLAUDE_CONFIG_DIR=$HOME/.claude-work claude"
alias claude-personal "env CLAUDE_CONFIG_DIR=$HOME/.claude-personal claude"
