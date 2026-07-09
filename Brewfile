# =============================================================================
# Brewfile - Package management for the development environment (macOS + Linux)
# =============================================================================
# Cross-platform: plain `brew` formulae install on both macOS and Linuxbrew.
# macOS-only entries (casks, mac-specific taps/formulae) live inside
# `if OS.mac?` blocks, which `brew bundle` evaluates natively.
# On Linux, install GUI apps and Nerd Fonts with the distro package manager.

# Taps
# -----------------------------------------------------------------------------
# Non-official taps must be trusted (Homebrew >= 6.0.0) before their formulae/
# casks will load. `trusted: true` declares this in-Brewfile so `brew bundle`
# works non-interactively and survives `brew bundle cleanup --force`.
tap "jesseduffield/lazygit", trusted: true
tap "arl/arl", trusted: true  # for gitmux
tap "jorgerojas26/lazysql", trusted: true # Lazysql
tap "oven-sh/bun", trusted: true  # Bun JavaScript runtime
tap "charmbracelet/tap", trusted: true
if OS.mac?
  tap "nikitabobko/tap", trusted: true # AeroSpace
  tap "FelixKratz/formulae", trusted: true # Sketchybar and JankyBorders
end

# Essential CLI Tools
# -----------------------------------------------------------------------------
brew "git"
brew "curl"
brew "wget"
brew "chezmoi"  # For dotfiles management
brew "fzf"   # Fuzzy finder
brew "ripgrep"  # Fast grep alternative
brew "bat"   # Better cat
brew "eza"   # Better ls
brew "fd"    # Better find
brew "jq"    # JSON processor
brew "yq"    # YAML processor
brew "gh"    # GitHub CLI
brew "glab"  # GitLab CLI
brew "htop"  # Process viewer
brew "neofetch"  # System info

# GNU utilities (better versions of macOS defaults; Linux ships these natively)
if OS.mac?
  brew "coreutils"
  brew "gnu-sed"
  brew "findutils"
  brew "gawk"
end

# Development Tools
# -----------------------------------------------------------------------------
brew "neovim", args: ["HEAD"]
brew "tmux"
brew "gitmux"
brew "git-lfs"
brew "lazygit"
brew "lazydocker"
brew "lazysql"
brew "charmbracelet/tap/crush"

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
brew "oven-sh/bun/bun"  # Fast JavaScript runtime, bundler, and package manager
brew "uv"  # Fast Python package installer and resolver
# Note: nvm for Node.js is installed via bootstrap.sh, uv for Python

# Cloud & DevOps
# -----------------------------------------------------------------------------
brew "kubectl"
brew "k9s"
brew "k3sup"
brew "helm"
brew "ansible"
# brew "docker"
cask "gcloud-cli" if OS.mac?  # Linux: install google-cloud-cli via distro repo
brew "awscli"
brew "tailscale"

# Utilities
# -----------------------------------------------------------------------------
brew "mosh"  # Mobile shell
brew "nmap"  # Network mapper
brew "cloc"  # Count lines of code
brew "gum"   # Glamorous shell scripts
brew "tz"    # Time zone helper
brew "teamookla/speedtest/speedtest", trusted: true  # Speedtest CLI

# Specialized tools
brew "joshmedeski/sesh/sesh", trusted: true

# GUI Applications (macOS only — casks don't exist on Linux;
# install equivalents with the distro package manager / Flatpak)
# -----------------------------------------------------------------------------
if OS.mac?
  # Window Management
  cask "aerospace"  # Tiling window manager
  brew "felixkratz/formulae/borders" # JankyBorders
  brew "felixkratz/formulae/sketchybar" # SketchyBar

  # Productivity
  cask "raycast"     # Spotlight replacement
  cask "claude"      # Claude Desktop
  cask "1password"   # Password manager
  cask "1password-cli"

  # Development
  cask "visual-studio-code"
  cask "claude-code" # Claude Code assistant
  # cask "docker-desktop"
  cask "rancher"
  cask "postman"     # API testing
  cask "bruno"

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

  # Fonts (Linux: download Nerd Fonts to ~/.local/share/fonts instead)
  cask "font-jetbrains-mono-nerd-font"
  cask "font-fira-code-nerd-font"
  cask "font-hack-nerd-font"
end

# Development Dependencies
# -----------------------------------------------------------------------------
brew "gcc"
brew "openssl"

# Optional/Project-specific (commented out by default)
# -----------------------------------------------------------------------------
# brew "postgresql", restart_service: true
# brew "redis", restart_service: true
brew "node"  # Use nvm instead
brew "python"  # Use uv instead
# brew "yarn"
# brew "hugo"
# brew "golang-migrate"
