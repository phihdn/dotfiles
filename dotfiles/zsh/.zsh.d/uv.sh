# UV (Python package installer and resolver) configuration

# Add uv to PATH if installed
if command -v uv &> /dev/null; then
    # Enable uv shell completion
    eval "$(uv generate-shell-completion zsh)"
    
    # Add uv-managed Python binaries to PATH
    export PATH="$HOME/.local/bin:$PATH"
    
    # Install latest Python as default if no default is set
    if ! command -v python &> /dev/null || [[ "$(python --version 2>&1)" == *"command not found"* ]]; then
        echo "Installing latest Python version as default with uv..."
        uv python install --default
    fi
fi
