#!/usr/bin/env bash

set -euo pipefail

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
  "tmux"
  "wakatime"
  "wezterm"
  "zsh"
)

# Install Xcode Command Line Tools if not already installed
if ! xcode-select -p &>/dev/null; then
  echo "Installing Xcode Command Line Tools..."
  xcode-select --install
  until xcode-select -p &>/dev/null; do
    sleep 5
  done
fi

# Install Homebrew if not already installed
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Install applications via Brewfile
if [[ -f ./Brewfile ]]; then
  echo "Installing applications from Brewfile..."
  brew bundle --file=./Brewfile
else
  echo "Warning: Brewfile not found in current directory"
fi

# Install Zap ZSH plugin manager
if [[ ! -d "${XDG_DATA_HOME:-$HOME/.local/share}/zap" ]]; then
  echo "Installing Zap ZSH plugin manager..."
  zsh <(curl -s https://raw.githubusercontent.com/zap-zsh/zap/master/install.zsh) --branch release-v1
  echo "Removing .zshrc so stow can manage it..."
  rm -f ~/.zshrc
fi

# Install nvm (Node Version Manager)
if [[ ! -d "$HOME/.config/nvm" ]]; then
  echo "Installing nvm (Node Version Manager)..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  # Move nvm to XDG config directory
  if [[ -d "$HOME/.nvm" ]]; then
    mkdir -p "$HOME/.config"
    mv "$HOME/.nvm" "$HOME/.config/nvm"
  fi
  
  # Install latest LTS Node.js and set as default (run once during installation)
  echo "Installing latest LTS Node.js and setting as default..."
  export NVM_DIR="$HOME/.config/nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  
  nvm install --lts
  nvm use --lts
  nvm alias default node
fi

# Re-source Homebrew env just in case
eval "$(/opt/homebrew/bin/brew shellenv)"

# Inject 1Password secrets if available
if command -v op &>/dev/null && [[ -f ./dotfiles/wakatime/wakatime.cfg.tpl ]]; then
  echo "Injecting 1Password secrets..."
  op inject -i ./dotfiles/wakatime/wakatime.cfg.tpl -o ./dotfiles/wakatime/.wakatime.cfg
fi

# Use GNU Stow to symlink dotfiles
echo "Setting up dotfiles with GNU Stow..."
for package in "${PACKAGES[@]}"; do
  if [[ -d "./dotfiles/$package" ]]; then
    echo "Installing $package..."
    stow --target="$HOME" --dir=./dotfiles "$package"
  else
    echo "Warning: Package $package not found, skipping..."
  fi
done

# Make scripts executable
if [[ -d "./dotfiles/scripts/.local/bin" ]]; then
  echo "Making scripts executable..."
  chmod +x ./dotfiles/scripts/.local/bin/*
fi

# Install latest Python version as default with uv
if command -v uv &>/dev/null; then
  echo "Installing latest Python version as default with uv..."
  uv python install --default
else
  echo "Warning: uv not found, skipping Python installation"
fi

# Optionally restart the shell
exec zsh -l
