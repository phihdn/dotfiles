#!/usr/bin/env bash

set -euo pipefail

# ============================================================================
# DOTFILES BOOTSTRAP SCRIPT
# ============================================================================
# Sets up a complete development environment by installing the necessary
# tools and applying dotfiles with chezmoi.
#
# This repository IS the chezmoi source. A `.chezmoiroot` file points chezmoi
# at the `home/` subdirectory, which mirrors $HOME using chezmoi's naming
# conventions (dot_, executable_, private_, *.tmpl).
# ============================================================================

# Absolute path to this repository (chezmoi source directory)
REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# OS detection — this script supports macOS (Darwin) and Linux
OS="$(uname -s)"

# Put Homebrew on PATH, wherever it lives (macOS arm64/Intel, Linuxbrew).
# Returns non-zero if no brew installation is found.
brew_shellenv() {
  local brew_bin
  for brew_bin in /opt/homebrew/bin/brew /usr/local/bin/brew \
                  /home/linuxbrew/.linuxbrew/bin/brew; do
    if [[ -x "$brew_bin" ]]; then
      eval "$("$brew_bin" shellenv)"
      return 0
    fi
  done
  return 1
}

# Color codes for output formatting
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly YELLOW='\033[1;33m'
readonly BLUE='\033[0;34m'
readonly CYAN='\033[0;36m'
readonly NC='\033[0m' # No Color

# Logging functions
log_info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

log_success() {
    echo -e "${GREEN}[SUCCESS]${NC} $1"
}

log_warn() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

log_error() {
    echo -e "${RED}[ERROR]${NC} $1" >&2
}

log_section() {
    echo
    echo -e "${CYAN}==>${NC} $1"
    echo
}

log_step() {
    echo -e "${BLUE}  →${NC} $1"
}

log_section "Installing Development Prerequisites"

if [[ "$OS" == "Darwin" ]]; then
  # Install Xcode Command Line Tools if not already installed
  log_step "Checking for Xcode Command Line Tools"
  if ! xcode-select -p &>/dev/null; then
    log_info "Xcode Command Line Tools not found, installing..."
    if xcode-select --install; then
      log_step "Waiting for Xcode Command Line Tools installation to complete"
      until xcode-select -p &>/dev/null; do
        sleep 5
      done
      log_success "Xcode Command Line Tools installed successfully"
    else
      log_error "Failed to install Xcode Command Line Tools"
      exit 1
    fi
  else
    log_success "Xcode Command Line Tools already installed"
  fi
else
  # Linux: Homebrew needs curl, git, and a compiler; install via distro first
  log_step "Checking for build prerequisites (curl, git, gcc)"
  missing=()
  for cmd in curl git gcc; do
    command -v "$cmd" &>/dev/null || missing+=("$cmd")
  done
  if (( ${#missing[@]} > 0 )); then
    log_error "Missing prerequisites: ${missing[*]}"
    log_error "Install them with your package manager first, e.g.:"
    log_error "  sudo apt-get install -y build-essential curl git   # Debian/Ubuntu"
    log_error "  sudo dnf install -y @development-tools curl git    # Fedora"
    exit 1
  fi
  log_success "Build prerequisites already installed"
fi

# Install Homebrew if not already installed (the official installer supports
# macOS and Linux; on Linux it installs to /home/linuxbrew/.linuxbrew)
log_step "Checking for Homebrew package manager"
if ! command -v brew &>/dev/null && ! brew_shellenv; then
  log_info "Homebrew not found, installing..."
  if /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
    log_step "Configuring Homebrew environment"
    if ! brew_shellenv; then
      log_error "Homebrew installed but no brew binary found on a known prefix"
      exit 1
    fi
    # Persist for login shells outside our zsh config (bash, first login)
    echo "eval \"\$(${HOMEBREW_PREFIX}/bin/brew shellenv)\"" >> ~/.zprofile
    log_success "Homebrew installed and configured successfully"
  else
    log_error "Failed to install Homebrew"
    exit 1
  fi
else
  brew_shellenv || true
  log_success "Homebrew already installed"
fi

log_section "Installing Applications and Dependencies"

# Install applications via Brewfile (includes chezmoi) and cleanup unlisted packages
log_step "Checking for Brewfile"
if [[ -f "${REPO_DIR}/Brewfile" ]]; then
  log_info "Installing applications from Brewfile..."
  if brew bundle --file="${REPO_DIR}/Brewfile"; then
    log_success "Applications installed successfully from Brewfile"

    log_step "Cleaning up packages not listed in Brewfile"
    if brew bundle cleanup --file="${REPO_DIR}/Brewfile" --force; then
      log_success "Package cleanup completed"
    else
      log_warn "Package cleanup encountered issues (non-critical)"
    fi
  else
    log_error "Failed to install applications from Brewfile"
    exit 1
  fi
else
  log_error "Brewfile not found in repository directory"
  exit 1
fi

# Re-source Homebrew env so freshly installed tools (chezmoi, op) are on PATH
brew_shellenv

log_section "Applying Dotfiles with chezmoi"

log_step "Verifying chezmoi is installed"
if ! command -v chezmoi &>/dev/null; then
  log_error "chezmoi not found on PATH after Brewfile install"
  exit 1
fi

# Point chezmoi at this repository as its source directory. The repo's
# .chezmoiroot file makes chezmoi use the home/ subdirectory automatically.
log_step "Configuring chezmoi source directory: ${REPO_DIR}"
mkdir -p "${HOME}/.config/chezmoi"
cat > "${HOME}/.config/chezmoi/chezmoi.toml" <<EOF
sourceDir = "${REPO_DIR}"
EOF

# Enable tracked git hooks so `git pull` auto-runs `chezmoi apply`
# (post-merge for merges, post-rewrite for rebases since pull.rebase = true).
log_step "Enabling git hooks (auto chezmoi apply on pull)"
git -C "${REPO_DIR}" config core.hooksPath .githooks

# The wakatime config template resolves a secret via the 1Password CLI. If op
# is not signed in yet, that single file will fail; the rest still applies and
# you can re-run "chezmoi apply" after signing in.
log_step "Applying dotfiles (chezmoi apply)"
if chezmoi apply --source "${REPO_DIR}"; then
  log_success "Dotfiles applied successfully"
else
  log_warn "chezmoi apply reported errors (often a not-signed-in 1Password CLI)."
  log_warn "Sign in with 'eval \$(op signin)' and re-run 'chezmoi apply'."
fi

log_section "Setting Up Shell Environment"

# The zsh config (alternative shell) uses a self-contained plugin manager:
# plugins are cloned into $ZDOTDIR/plugins on first interactive zsh launch,
# so no plugin-manager bootstrap step is required here.

# Install tpm (tmux plugin manager). The tmux config sources it at the end and
# lists plugins with `set -g @plugin`; without this clone, tpm's prefix+I /
# prefix+U bindings silently never get created.
log_step "Checking for tpm (tmux plugin manager)"
TPM_DIR="$HOME/.config/tmux/plugins/tpm"
if [[ ! -d "$TPM_DIR" ]]; then
  log_info "Installing tpm (tmux plugin manager)..."
  if git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM_DIR"; then
    log_success "tpm installed successfully"
    # Install the plugins declared in tmux.conf without needing prefix+I
    log_step "Installing tmux plugins"
    if "$TPM_DIR/bin/install_plugins"; then
      log_success "tmux plugins installed"
    else
      log_warn "tmux plugin install encountered issues (run prefix+I inside tmux to retry)"
    fi
  else
    log_error "Failed to install tpm"
    exit 1
  fi
else
  log_success "tpm already installed"
fi

# Install nvm (Node Version Manager)
log_step "Checking for nvm (Node Version Manager)"
if [[ ! -d "$HOME/.config/nvm" ]]; then
  log_info "Installing nvm (Node Version Manager)..."
  if curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash; then
    log_success "nvm installed successfully"

    # Move nvm to XDG config directory
    if [[ -d "$HOME/.nvm" ]]; then
      log_step "Moving nvm to XDG config directory"
      mkdir -p "$HOME/.config"
      mv "$HOME/.nvm" "$HOME/.config/nvm"
      log_info "nvm moved to $HOME/.config/nvm"
    fi

    # Install latest LTS Node.js and set as default (run once during installation)
    log_step "Installing latest LTS Node.js and setting as default"
    export NVM_DIR="$HOME/.config/nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

    if nvm install --lts && nvm use --lts && nvm alias default node; then
      log_success "Latest LTS Node.js installed and set as default"
    else
      log_warn "Node.js installation encountered issues (may need manual setup)"
    fi
  else
    log_error "Failed to install nvm"
    exit 1
  fi
else
  log_success "nvm already installed"
fi

log_section "Setting Up Python Environment"

# Install latest Python version as default with uv
log_step "Checking for uv Python version manager"
if command -v uv &>/dev/null; then
  log_info "Installing latest Python version as default with uv..."
  if uv python install --default; then
    log_success "Latest Python version installed as default with uv"
  else
    log_warn "Python installation with uv encountered issues (may need manual setup)"
  fi
else
  log_info "uv not found, skipping Python installation"
fi

log_section "Setting Default Shell"

# Set zsh as the default shell. Prefer Homebrew zsh; fall back to the system
# zsh (common on Linux where zsh comes from the distro). Fish remains fully
# configured and can be launched with `fish` or set as default instead.
log_step "Setting zsh as default shell"
ZSH_PATH=$(brew --prefix)/bin/zsh
[[ -x "$ZSH_PATH" ]] || ZSH_PATH="$(command -v zsh || true)"
if [[ -x "$ZSH_PATH" ]]; then
  if ! grep -q "^${ZSH_PATH}$" /etc/shells; then
    log_info "Adding zsh to /etc/shells..."
    echo "$ZSH_PATH" | sudo tee -a /etc/shells
  fi
  if [[ "$SHELL" != "$ZSH_PATH" ]]; then
    log_info "Changing default shell to zsh..."
    # chsh can prompt for a password (Linux PAM) and fail non-interactively;
    # don't let that abort the rest of the bootstrap.
    if chsh -s "$ZSH_PATH"; then
      log_success "Default shell changed to zsh"
    else
      log_warn "chsh failed; change manually with: chsh -s $ZSH_PATH"
    fi
  else
    log_success "zsh is already the default shell"
  fi
else
  log_warn "zsh not found (Homebrew or system), keeping current shell"
fi

log_section "Setting Up Shell Completions"

# Generate kubectl completions for fish
log_step "Generating kubectl completions for fish"
if command -v kubectl &>/dev/null && command -v fish &>/dev/null; then
  FISH_COMPLETIONS_DIR="$HOME/.config/fish/completions"
  mkdir -p "$FISH_COMPLETIONS_DIR"
  if kubectl completion fish > "$FISH_COMPLETIONS_DIR/kubectl.fish"; then
    log_success "kubectl completions generated for fish"
  else
    log_warn "Failed to generate kubectl completions"
  fi
else
  log_info "kubectl or fish not found, skipping completions"
fi

log_section "Setting Up Claude Code Accounts"

# Two Claude Code accounts (work + personal) via separate CLAUDE_CONFIG_DIRs.
# The `claude-work` / `claude-personal` aliases (in zsh & fish) point Claude at
# these dirs so logins, history, projects, and sessions stay isolated. Shared
# config (skills, agents, commands, settings, hooks, ...) is symlinked from
# ~/.claude so there is a single source of truth. Run `/login` once per alias.
log_step "Seeding Claude account config directories"
if [[ -d "$HOME/.claude" ]]; then
  claude_shared=(CLAUDE.md settings.json statusline.cjs agents commands hooks \
    output-styles rules schemas scripts skills plugins workflows)
  for claude_dir in "$HOME/.claude-work" "$HOME/.claude-personal"; do
    mkdir -p "$claude_dir"
    for item in "${claude_shared[@]}"; do
      [[ -e "$HOME/.claude/$item" ]] && ln -sfn "$HOME/.claude/$item" "$claude_dir/$item"
    done
  done
  log_success "Claude account dirs ready (~/.claude-work, ~/.claude-personal)"
  log_info "Sign in once per account: 'claude-work' then /login; 'claude-personal' then /login"
else
  log_info "~/.claude not found, skipping Claude multi-account setup"
fi

log_section "Bootstrap Complete"

log_success "Dotfiles bootstrap completed successfully!"
log_info "Manage your dotfiles with: chezmoi diff | chezmoi apply | chezmoi edit <file>"
log_info "Restart your terminal or run 'exec zsh -l' to load your new shell config."
