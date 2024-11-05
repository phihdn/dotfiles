#!/usr/bin/env bash
if ! command -v brew &>/dev/null; then
  echo "Installing Homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
fi

echo "Installing homebrew packages..."

brew bundle install --file=$HOME/dotfiles/homebrew/Phi.Brewfile

