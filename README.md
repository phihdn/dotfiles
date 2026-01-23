# 🛠️ MacAutoSetup

A lean, modern development environment for macOS that brings the best terminal-first, keyboard-driven workflow to Mac — with minimal fuss.

*Inspired by [NLaundry/MacAutoSetup](https://github.com/NLaundry/MacAutoSetup)*

## ✨ Core Features

* 🐟 **Fish shell** — user-friendly shell with great defaults (default)
* 🧠 **Raycast** — fast launcher & automation
* 🪟 **AeroSpace** — tiling window management (like i3, for Mac)
* 🧑‍💻 **Neovim** — full-featured, modern editor configuration
* 🖋️ **GNU Stow** — simple, modular dotfile management
* 🧰 **Essential CLI tools** — ripgrep, fzf, bat, eza, and more
* 🚀 **Zsh** — alternative shell with Zinit plugins
* 🌟 **Starship** — beautiful, fast cross-shell prompt

## 🎯 Philosophy

* **Terminal-first, keyboard-driven workflow**
* **Get up and running fast** — minimal configuration overhead
* **Modular, understandable configuration** — no hidden magic
* **Leverage community standards** — use well-maintained tools
* **Dotfile hygiene** — organized, clean, and portable

## 🚀 Installation

```bash
git clone https://github.com/yourusername/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap.sh
```

This will:
1. Install Xcode CLI tools (if needed)
2. Install Homebrew (if needed)
3. Install packages from Brewfile
4. Install Zinit (Zsh plugin manager)
5. Inject 1Password secrets (if available)
6. Symlink all dotfiles with GNU Stow

**Note:** After bootstrap, run `chsh -s $(which fish)` to set Fish as default shell.

## 📦 What Gets Installed

### 🧰 Essential CLI Tools
- **git**, **gh** — Version control and GitHub CLI
- **fzf**, **ripgrep**, **bat** — Modern search and file tools
- **eza**, **fd**, **lsd** — Better ls and find alternatives
- **htop**, **neofetch** — System monitoring and info
- **tmux**, **sesh**, **starship** — Terminal multiplexer and prompt
- **stow** — Dotfile management
- **jq** — JSON processor
- **lf** — Terminal file manager

### 🛠️ Development Tools
- **neovim** — Modern Vim-based editor with Lua config
- **lazygit**, **lazydocker** — TUI for Git and Docker
- **kubectl**, **k9s**, **helm** — Kubernetes tools
- **uv**, **go**, **rust** — Language version managers and package installers
- **wakatime** — Development time tracking

### 💻 GUI Applications
- **AeroSpace** — Tiling window manager for macOS
- **Raycast** — Spotlight replacement
- **1Password** — Password manager with CLI
- **Visual Studio Code** — Code editor
- **WezTerm**, **Ghostty**, **Kitty** — Modern terminal emulators
- **Docker** — Containerization
- **Obsidian** — Note-taking

### 🖥️ Fonts
- **JetBrains Mono Nerd Font** — Coding font with icons
- **Fira Code Nerd Font** — Alternative coding font with ligatures
- **Hack Nerd Font** — Clean coding font option

## 📁 Dotfiles Structure

Dotfiles are managed using **GNU Stow** for clean, modular organization:

```
dotfiles/
├── zsh/          # Zsh configuration
├── fish/         # Fish shell configuration  
├── nvim/         # Neovim configuration
├── git/          # Git configuration
├── tmux/         # Tmux configuration
├── aerospace/    # AeroSpace window manager
├── starship/     # Starship prompt
├── wezterm/      # WezTerm terminal
├── scripts/      # Custom utility scripts
└── ...
```

Each folder mirrors the target filesystem structure from `$HOME`:

```bash
# Example: Installing nvim config
stow --target=$HOME nvim
# Creates: ~/.config/nvim -> ~/dotfiles/nvim/.config/nvim
```

## 🚀 Usage

### Install everything
```bash
./bootstrap.sh
```

### Install specific packages
```bash
cd dotfiles
stow nvim fish tmux  # Only these packages
```

### Uninstall specific packages
```bash
cd dotfiles
stow -D nvim  # Remove nvim config
```

### Preview changes (dry run)
```bash
stow -n -v nvim  # See what would be linked
```

### Homebrew Package Management
```bash
# Sync packages with Brewfile (install + cleanup)
brew-sync

# Preview what packages would be removed
brew-sync preview

# Only install packages from Brewfile
brew-sync install

# Only cleanup packages not in Brewfile
brew-sync cleanup

# Force sync without prompting
brew-sync force
```

## 🐍🟢 Language Version Management

This setup includes modern tools for managing Node.js and Python versions:

### 📦 Node.js with nvm

**nvm** (Node Version Manager) is automatically installed and configured for Node.js version management.

#### Basic Usage
```bash
# List available Node.js versions
nvm list-remote

# Install latest LTS version
nvm install --lts

# Install specific version
nvm install 18.19.0

# Use specific version
nvm use 18.19.0

# Set default version
nvm alias default 18.19.0

# List installed versions
nvm list

# Install packages globally for current version
npm install -g pnpm yarn typescript
```

#### Project-specific Node versions
```bash
# Create .nvmrc file in project root
echo "18.19.0" > .nvmrc

# Use version from .nvmrc
nvm use

# Auto-switch when entering directory (add to shell config)
cd my-project  # Automatically switches to .nvmrc version
```

### 🐍 Python with uv

**uv** is a fast Python package installer and resolver that replaces pip, pip-tools, and virtualenv.

#### Basic Usage
```bash
# Install Python versions
uv python install 3.12
uv python install 3.11

# List installed Python versions
uv python list

# Create new project with virtual environment
uv init my-python-project
cd my-python-project

# Add dependencies
uv add requests pandas numpy
uv add pytest --dev  # Development dependency

# Install dependencies from pyproject.toml
uv sync

# Run Python with project environment
uv run python script.py
uv run pytest

# Activate virtual environment manually
source .venv/bin/activate  # or use uv shell
```

#### Advanced uv Usage
```bash
# Create project with specific Python version
uv init --python 3.11 my-project

# Add dependency with version constraint
uv add "django>=4.0,<5.0"

# Update dependencies
uv lock --upgrade

# Export requirements.txt (for compatibility)
uv export --format requirements-txt --output-file requirements.txt

# Run commands in virtual environment
uv run --python 3.12 python script.py

# Install package globally
uv tool install black
uv tool install ruff

# List global tools
uv tool list
```

#### Project Structure with uv
```
my-python-project/
├── pyproject.toml     # Project metadata and dependencies
├── uv.lock           # Lockfile with exact versions
├── .venv/            # Virtual environment (auto-created)
├── src/
│   └── my_package/
└── tests/
```

#### Migration from pip/pipenv/poetry
```bash
# From requirements.txt
uv add -r requirements.txt

# From Pipfile
uv add $(cat Pipfile | grep -E '^[a-zA-Z]' | cut -d' ' -f1)

# From poetry (copy dependencies from pyproject.toml)
uv add package1 package2 package3
```

### 🔄 Switching Between Versions

#### Node.js Version Switching
```bash
# Quick version switching
nvm use 16    # Switch to Node 16
nvm use 18    # Switch to Node 18
nvm use node  # Switch to latest

# Project-based switching (with .nvmrc)
echo "18.19.0" > .nvmrc
nvm use  # Uses version from .nvmrc
```

#### Python Version Switching
```bash
# Project-specific Python (via pyproject.toml)
[tool.uv]
python = "3.11"

# Or specify when creating project
uv init --python 3.11 my-project

# Run with specific Python version
uv run --python 3.12 python script.py
```

### 💡 Pro Tips

#### Node.js Tips
- Use `.nvmrc` files for consistent Node versions across team
- Install global packages after switching Node versions
- Use `nvm alias` to create shortcuts for frequently used versions

#### Python Tips  
- Use `uv sync` to ensure dependencies match lockfile exactly
- Leverage `uv run` to avoid manual virtual environment activation
- Use `uv tool install` for global Python tools (black, ruff, etc.)
- Pin Python versions in `pyproject.toml` for team consistency

#### Performance
- **uv is 10-100x faster** than pip for package installation
- **nvm** provides instant Node.js version switching
- Both tools cache downloads for faster subsequent installs

## 📋 Available Packages

**Total: 20 packages** organized by category:

### 🖥️ Terminal Emulators
- **ghostty**, **kitty**, **wezterm** - Modern GPU-accelerated terminals

### 🐚 Shells & Prompts  
- **fish**, **zsh** - Modern shell configurations
- **starship** - Beautiful cross-shell prompt

### ⚡ CLI Tools & Utilities
- **bat** - Enhanced cat with syntax highlighting
- **lf** - Terminal file manager
- **lsd** - Enhanced ls with colors and icons
- **neofetch** - System information display
- **scripts** - Custom utility scripts

### 🧑‍💻 Development Tools
- **git** - Version control configuration
- **lazygit** - Git TUI interface
- **nvim** - Modern Vim-based editor
- **tmux** - Terminal multiplexer
- **sesh** - tmux session manager

### ☁️ Cloud & DevOps
- **k9s** - Kubernetes cluster management

### 🔐 Security & Productivity
- **1password** - Password manager and SSH agent
- **wakatime** - Development time tracking

### 🪟 Window Management
- **aerospace** - Tiling window manager for macOS

---

| Package | Description |
|---------|-------------|
| **1password** | 1Password CLI and SSH agent configuration |
| **aerospace** | AeroSpace tiling window manager configuration |
| **bat** | bat (cat clone) with syntax highlighting themes |
| **fish** | Fish shell configuration and plugins |
| **git** | Git configuration, aliases, and settings |
| **ghostty** | Ghostty terminal emulator configuration |
| **k9s** | Kubernetes CLI (k9s) configuration and themes |
| **kitty** | Kitty terminal emulator configuration |
| **lazygit** | Lazygit TUI configuration and themes |
| **lf** | lf file manager configuration and settings |
| **lsd** | lsd (ls deluxe) configuration and colors |
| **neofetch** | Neofetch system information display configuration |
| **nvim** | Neovim configuration with Lua and plugins |
| **scripts** | Custom utility scripts and tools |
| **sesh** | Sesh tmux session manager configuration |
| **starship** | Starship cross-shell prompt configuration |
| **tmux** | tmux terminal multiplexer configuration and plugins |
| **wakatime** | WakaTime time tracking configuration |
| **wezterm** | WezTerm terminal emulator configuration |
| **zsh** | Zsh shell configuration with modular .zsh.d structure |

## ✅ Result

After installation, you'll have:
* **Modern terminal environment** with beautiful, fast tools
* **Tiling window management** for efficient screen usage
* **Powerful editor** ready for development
* **Clean shell** with helpful aliases and functions
* **Development tools** for Python, Node, Go, Rust, and Kubernetes
* **Consistent experience** across different machines

## 🔄 Updating

To update your dotfiles:

```bash
cd ~/dotfiles
git pull
./bootstrap.sh  # Reinstall with updates
```

## 🛠️ Customization

### Adding new packages
1. Create a new directory in `dotfiles/`
2. Structure it to mirror your home directory
3. Add the package name to `PACKAGES` array in `bootstrap.sh`
4. Run `./bootstrap.sh` or `stow package-name`

### Modifying existing configs
1. Edit files in the `dotfiles/` directory
2. Changes are immediately reflected (symlinks!)
3. Commit and push your changes

### Ignoring files from stow
Use `.stow-local-ignore` in individual packages or `.stow-global-ignore` at the root:
- Template files (`.tpl`, `.template`, `.example`)
- Backup files (`.backup`, `.bak`)
- Documentation files (`README.*`, `LICENSE.*`)
- Temporary files (`.tmp`, `.swp`)

## 🆘 Troubleshooting

### Conflicts during installation
```bash
# Option 1: Remove conflicting files
rm ~/.config/nvim/init.lua

# Option 2: Adopt existing files into stow
stow --adopt nvim
```

### Broken symlinks after moving dotfiles
```bash
./bootstrap.sh  # Reinstall everything
```

### Check what stow would do
```bash
stow -n -v package-name  # Dry run with verbose output
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test the installation
5. Submit a pull request

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

---

**Enjoy your new development setup! 🚀**