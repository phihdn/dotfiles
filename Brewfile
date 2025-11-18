# =============================================================================
# Brewfile - Package management for macOS development environment
# =============================================================================

# Taps
# -----------------------------------------------------------------------------
tap "jesseduffield/lazygit"
tap "arl/arl"  # for gitmux
tap "jorgerojas26/lazysql" # Lazysql

# Essential CLI Tools
# -----------------------------------------------------------------------------
brew "git"
brew "curl"
brew "wget"
brew "stow"  # For dotfiles management
brew "fzf"   # Fuzzy finder
brew "ripgrep"  # Fast grep alternative
brew "bat"   # Better cat
brew "eza"   # Better ls
brew "fd"    # Better find
brew "jq"    # JSON processor
brew "yq"    # YAML processor
brew "gh"    # GitHub CLI
brew "htop"  # Process viewer
brew "neofetch"  # System info

# GNU utilities (better versions of macOS defaults)
brew "coreutils"
brew "gnu-sed"
brew "findutils"
brew "gawk"

# Development Tools
# -----------------------------------------------------------------------------
brew "neovim", args: ["HEAD"]
brew "tmux"
brew "gitmux"
brew "git-lfs"
brew "lazygit"
brew "lazydocker"
brew "lazysql"

# Shell & Terminal
# -----------------------------------------------------------------------------
brew "zsh"
brew "fish"
brew "starship"  # Cross-shell prompt
brew "zoxide"    # Smart cd

# File Management
# -----------------------------------------------------------------------------
brew "lf"   # Terminal file manager
brew "lsd"  # ls deluxe

# Programming Languages & Version Managers
# -----------------------------------------------------------------------------
brew "go"
brew "rust"
brew "uv"  # Fast Python package installer and resolver
# Note: nvm for Node.js is installed via bootstrap.sh, uv for Python

# Cloud & DevOps
# -----------------------------------------------------------------------------
brew "kubectl"
brew "k9s"
brew "k3sup"
brew "helm"
brew "ansible"
brew "docker"
brew "awscli"
brew "tailscale"

# Utilities
# -----------------------------------------------------------------------------
brew "mosh"  # Mobile shell
brew "nmap"  # Network mapper
brew "cloc"  # Count lines of code
brew "gum"   # Glamorous shell scripts
brew "tz"    # Time zone helper
brew "teamookla/speedtest/speedtest"  # Speedtest CLI

# Specialized tools
brew "joshmedeski/sesh/sesh"

# GUI Applications
# -----------------------------------------------------------------------------

# Window Management
cask "nikitabobko/tap/aerospace"  # Tiling window manager

# Productivity
cask "raycast"     # Spotlight replacement
cask "1password"   # Password manager
cask "1password-cli"

# Development
cask "visual-studio-code"
cask "docker-desktop"
cask "postman"     # API testing
cask "figma"       # Design tool

# Terminals
cask "wezterm"     # GPU-accelerated terminal
cask "ghostty"     # Fast terminal (if available)
cask "kitty"       # Alternative terminal

# Browsers
cask "google-chrome"

# Communication
cask "discord"
cask "zoom"

# Media & Utilities
cask "obs"         # Screen recording
cask "obsidian"    # Note-taking
cask "calibre"     # E-book management
cask "audacity"    # Audio editing
cask "netnewswire" # RSS reader
cask "itsycal"     # Menu bar calendar
cask "keycastr"    # Keystroke visualizer
cask "balenaetcher" # USB flashing tool

# Fonts
# -----------------------------------------------------------------------------
cask "font-jetbrains-mono-nerd-font"
cask "font-fira-code-nerd-font"
cask "font-hack-nerd-font"

# Development Dependencies
# -----------------------------------------------------------------------------
brew "gcc"
brew "openssl"

# Optional/Project-specific (commented out by default)
# -----------------------------------------------------------------------------
# brew "postgresql", restart_service: true
# brew "redis", restart_service: true
# brew "node"  # Use nvm instead
# brew "python"  # Use uv instead
# brew "yarn"
# brew "hugo"
# brew "golang-migrate"
