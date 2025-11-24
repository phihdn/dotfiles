#!/usr/bin/env bash

set -euo pipefail

# ============================================================================
# DOTFILES BOOTSTRAP SCRIPT
# ============================================================================
# This script sets up a complete development environment by installing
# necessary tools and symlinking dotfiles using GNU Stow.
# ============================================================================

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

# Centralized list of dotfiles packages
PACKAGES=(
  "1password"
  "aerospace"
  "bat"
  "git"
  "ghostty"
  "k9s"
  "kitty"
  "lazygit"
  "lf"
  "lsd"
  "neofetch"
  "nvim"
  "scripts"
  "sesh"
  "starship"
  "sketchybar"
  "jankyborders"
  "tmux"
  "wakatime"
  "wezterm"
  "zsh"
)

log_section "Installing Development Prerequisites"

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

# Install Homebrew if not already installed
log_step "Checking for Homebrew package manager"
if ! command -v brew &>/dev/null; then
  log_info "Homebrew not found, installing..."
  if /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; then
    log_step "Configuring Homebrew environment"
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
    log_success "Homebrew installed and configured successfully"
  else
    log_error "Failed to install Homebrew"
    exit 1
  fi
else
  log_success "Homebrew already installed"
fi

log_section "Installing Applications and Dependencies"

# Install applications via Brewfile and cleanup unlisted packages
log_step "Checking for Brewfile"
if [[ -f ./Brewfile ]]; then
  log_info "Installing applications from Brewfile..."
  if brew bundle --file=./Brewfile; then
    log_success "Applications installed successfully from Brewfile"
    
    log_step "Cleaning up packages not listed in Brewfile"
    if brew bundle cleanup --file=./Brewfile --force; then
      log_success "Package cleanup completed"
    else
      log_warn "Package cleanup encountered issues (non-critical)"
    fi
  else
    log_error "Failed to install applications from Brewfile"
    exit 1
  fi
else
  log_error "Brewfile not found in current directory"
  log_info "Please ensure you're running this script from the dotfiles root directory"
  exit 1
fi

log_section "Setting Up Shell Environment"

# Install Zinit ZSH plugin manager
log_step "Checking for Zinit ZSH plugin manager"
ZINIT_HOME="${XDG_DATA_HOME:-${HOME}/.local/share}/zinit/zinit.git"
if [[ ! -d "$ZINIT_HOME" ]]; then
  log_info "Installing Zinit plugin manager..."
  if bash -c "$(curl --fail --show-error --silent --location https://github.com/zdharma-continuum/zinit/raw/refs/heads/main/scripts/install.sh)"; then
    log_success "Zinit installed successfully"
    
    log_step "Removing default .zshrc to allow stow management"
    rm -f ~/.zshrc
    log_info "Default .zshrc removed (will be managed by stow)"
  else
    log_error "Failed to install Zinit plugin manager"
    exit 1
  fi
else
  log_success "Zinit already installed"
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

log_section "Configuring Secrets and Environment"

# Re-source Homebrew env just in case
log_step "Re-sourcing Homebrew environment"
eval "$(/opt/homebrew/bin/brew shellenv)"

# Inject 1Password secrets if available
log_step "Checking for 1Password CLI and secret templates"
if command -v op &>/dev/null && [[ -f ./dotfiles/wakatime/wakatime.cfg.tpl ]]; then
  log_info "Injecting 1Password secrets into configuration files..."
  if op inject -i ./dotfiles/wakatime/wakatime.cfg.tpl -o ./dotfiles/wakatime/.wakatime.cfg; then
    log_success "1Password secrets injected successfully"
  else
    log_warn "Failed to inject 1Password secrets (may need manual configuration)"
  fi
else
  if ! command -v op &>/dev/null; then
    log_info "1Password CLI not available, skipping secret injection"
  else
    log_info "No secret templates found, skipping secret injection"
  fi
fi

log_section "Installing Dotfiles Configuration"

# Clean up macOS metadata files that can cause stow conflicts
log_step "Cleaning up macOS metadata files"
if find ./dotfiles -name ".DS_Store" -type f -delete 2>/dev/null; then
  log_info "Removed .DS_Store files to prevent stow conflicts"
fi

# Use GNU Stow to symlink dotfiles
log_info "Setting up dotfiles with GNU Stow..."
package_count=0
installed_count=0

for package in "${PACKAGES[@]}"; do
  ((package_count++))
  log_step "Processing package: $package ($package_count/${#PACKAGES[@]})"
  
  if [[ -d "./dotfiles/$package" ]]; then
    if stow --target="$HOME" --dir=./dotfiles "$package"; then
      log_success "Package '$package' installed successfully"
      ((installed_count++))
    else
      log_error "Failed to install package '$package'"
      exit 1
    fi
  else
    log_warn "Package '$package' directory not found, skipping..."
  fi
done

log_success "Dotfiles installation completed: $installed_count/$package_count packages installed"

log_section "Configuring Scripts and Permissions"

# Make scripts executable
log_step "Checking for custom scripts directory"
if [[ -d "./dotfiles/scripts/.local/bin" ]]; then
  log_info "Making scripts executable..."
  script_count=0
  
  for script in ./dotfiles/scripts/.local/bin/*; do
    if [[ -f "$script" ]]; then
      ((script_count++))
      script_name=$(basename "$script")
      log_step "Making '$script_name' executable"
      
      if chmod +x "$script"; then
        log_info "✓ $script_name"
      else
        log_warn "Failed to make '$script_name' executable"
      fi
    fi
  done
  
  if [[ $script_count -gt 0 ]]; then
    log_success "$script_count scripts made executable"
  else
    log_info "No scripts found in directory"
  fi
else
  log_info "Scripts directory not found, skipping..."
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
  log_info "Install uv manually if you need Python version management"
fi

log_section "Bootstrap Complete"

log_success "Dotfiles bootstrap completed successfully!"
log_info "Restarting shell to apply all configurations..."

# Restart the shell to apply all configurations
exec zsh -l
