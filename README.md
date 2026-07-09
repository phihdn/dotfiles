# 🛠️ MacAutoSetup

A lean, modern development environment for macOS that brings the best terminal-first, keyboard-driven workflow to Mac — with minimal fuss.

*Inspired by [NLaundry/MacAutoSetup](https://github.com/NLaundry/MacAutoSetup)*

## ✨ Core Features

* 🐟 **Fish shell** — user-friendly shell with great defaults (alternative)
* 🧠 **Raycast** — fast launcher & automation
* 🪟 **AeroSpace** — tiling window management (like i3, for Mac)
* 🧑‍💻 **Neovim** — full-featured, modern editor configuration
* 🖋️ **chezmoi** — declarative, template-aware dotfile management
* 🧰 **Essential CLI tools** — ripgrep, fzf, bat, eza, and more
* 🚀 **Zsh** — default shell with a modular XDG config (`~/.config/zsh`) and a self-contained plugin manager
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
3. Install packages from Brewfile (including chezmoi)
4. Point chezmoi's `sourceDir` at this repo and run `chezmoi apply`
5. Install nvm (zsh plugins self-install on first launch)
6. Set zsh as the default shell (fish stays available via `fish`)

Secrets (e.g. the WakaTime API key) are resolved from 1Password at apply time.
If the `op` CLI isn't signed in yet, sign in and re-run `chezmoi apply`.

### 🐧 Linux support

The repo works on Linux too. `bootstrap.sh` detects the OS: on Linux it skips
Xcode tools (checks for `curl`/`git`/`gcc` instead — install `build-essential`
or equivalent first), installs Homebrew to `/home/linuxbrew/.linuxbrew`, and
falls back to the system zsh for the default shell. OS-specific handling:

- **Brewfile** — casks and mac-only formulae are wrapped in `if OS.mac?`;
  on Linux install GUI apps and Nerd Fonts via your distro/Flatpak.
- **chezmoi templates** — `~/.gitconfig*` pick the right 1Password
  `op-ssh-sign` path per OS (`/opt/1Password/op-ssh-sign` on Linux), and
  `home/.chezmoiignore` skips macOS-only app configs (AeroSpace, SketchyBar,
  JankyBorders) on Linux.
- **Shells** — zsh and fish detect the Homebrew prefix at runtime
  (`HOMEBREW_PREFIX`), so PATH works with macOS arm64/Intel brew and Linuxbrew.

## 📦 What Gets Installed

### 🧰 Essential CLI Tools
- **git**, **gh** — Version control and GitHub CLI
- **fzf**, **ripgrep**, **bat** — Modern search and file tools
- **eza**, **fd**, **lsd** — Better ls and find alternatives
- **htop**, **neofetch** — System monitoring and info
- **tmux**, **sesh**, **starship** — Terminal multiplexer and prompt
- **chezmoi** — Dotfile management
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

Dotfiles are managed using **chezmoi**. This repository is the chezmoi *source directory*. A `.chezmoiroot` file at the repo root contains `home`, so chezmoi treats the `home/` subdirectory as the source and applies it to `$HOME`.

```
.
├── .chezmoiroot        # contains "home" → chezmoi source is home/
├── Brewfile            # Homebrew packages
├── bootstrap.sh        # installer
├── README.md
└── home/               # chezmoi source (mirrors $HOME)
    ├── dot_zshenv                → ~/.zshenv (bootstraps ZDOTDIR)
    ├── dot_gitconfig             → ~/.gitconfig
    ├── private_dot_wakatime.cfg.tmpl → ~/.wakatime.cfg (0600, templated secret)
    ├── dot_local/bin/executable_*    → ~/.local/bin/*  (executable)
    └── dot_config/               → ~/.config/
        ├── zsh/                  → ~/.config/zsh/ (modular: .zshrc, aliases.zsh, plugins.zsh, ...)
        ├── nvim/ fish/ tmux/ aerospace/ starship.toml ...
```

chezmoi's naming conventions encode file attributes:

| Source name | Target | Meaning |
|-------------|--------|---------|
| `dot_config/` | `~/.config/` | leading dot |
| `executable_foo` | `~/foo` (`+x`) | executable bit |
| `private_foo` | `~/foo` (`0600`) | restricted perms |
| `foo.tmpl` | `~/foo` | Go template (secrets, host vars) |

### Configuration reference

Annotated view of what each managed config is for:

```
home/
├── dot_zshenv                    → ~/.zshenv               zsh bootstrap (points ZDOTDIR at ~/.config/zsh)
├── dot_gitconfig                 → ~/.gitconfig            git identity + 1Password SSH signing
├── dot_gitconfig-personal        → ~/.gitconfig-personal   included for repos under ~/ws/personal/
├── dot_gitconfig-work       → ~/.gitconfig-work  included for repos under ~/ws/work/work/
├── private_dot_wakatime.cfg.tmpl → ~/.wakatime.cfg         WakaTime (API key pulled from 1Password, 0600)
├── dot_local/bin/executable_*    → ~/.local/bin/*          user scripts (brew-sync, sesh_start, git-bare-clone, ...)
└── dot_config/                   → ~/.config/
    ├── zsh/           zsh shell config — modular (see "zsh configuration" below)
    ├── fish/          fish shell config (config.fish, conf.d/, functions/)
    ├── nvim/          Neovim — Lua config under lua/phihdn/{core,plugins}
    ├── tmux/          tmux config + gitmux + catppuccin theme
    ├── starship.toml  Starship prompt (shared by zsh and fish)
    ├── aerospace/     AeroSpace tiling window manager
    ├── sketchybar/    menu bar (executable plugins/)
    ├── borders/       JankyBorders (executable bordersrc)
    ├── ghostty/       terminal emulator
    ├── kitty/         terminal emulator
    ├── wezterm/       terminal emulator (Lua)
    ├── bat/           bat config + Catppuccin/Kanagawa themes
    ├── lazygit/       lazygit TUI config
    ├── lf/            lf file manager (lfrc + executable previewer.sh)
    ├── lsd/           lsd (ls replacement) config + colors
    ├── k9s/           k9s config + skins (per-cluster state ignored)
    ├── sesh/          sesh tmux session manager
    ├── neofetch/      neofetch system info
    └── 1Password/ssh/agent.toml   1Password SSH agent config
```

### zsh configuration (`~/.config/zsh`, `ZDOTDIR`)

The zsh config is split into small, single-purpose modules. `~/.zshenv` is the
only zsh file kept in `$HOME`; it sets `ZDOTDIR` to `~/.config/zsh` so every
other file lives there and `$HOME` stays clean.

| File | Purpose |
|------|---------|
| `~/.zshenv` (`dot_zshenv`) | Minimal bootstrap. Sets `XDG_CONFIG_HOME` and `ZDOTDIR=~/.config/zsh`, then sources `$ZDOTDIR/.zshenv`. Read by **every** zsh invocation. |
| `.zshenv` | Environment for all shells: XDG dirs, `EDITOR`/`VISUAL=nvim`, `MANPAGER=bat`, `GPG_TTY`, `KUBECONFIG`, `K9S_CONFIG_DIR`, and a deduplicated `PATH` (including nvm's default node — see below). |
| `.zprofile` | Login shells only. Re-prepends nvm's node to `PATH` after macOS `path_helper` reorders it (see [node / nvm on PATH](#node--nvm-on-path)). |
| `.zshrc` | Interactive setup: history, shell options, completion (`compinit`), `zoxide`, fzf key-bindings, `kubectl` completion, lazy `nvm` + `uv` completion, then sources the modules below. |
| `fzf.zsh` | fzf defaults (`fd` source, `bat` preview, UI options) and the `Ctrl-F` file-picker widget. |
| `aliases.zsh` | Aliases (git, kubernetes, `lsd`/`eza`, `bat`, `rg`, sesh) and helper functions (`lf` dir-follow). |
| `bindings.zsh` | Key-bindings and vi-mode cursor settings. Defines the `zvm_after_init` hook **before** plugins load so custom bindings survive zsh-vi-mode's reset. |
| `plugins.zsh` | Self-contained plugin manager: clones plugins into `~/.config/zsh/plugins` on first launch and sources them. Run `zplugin-update` to update. |
| `prompt.zsh` | Initializes the Starship prompt (or a minimal `$` prompt inside Cursor Agent). |

Plugins loaded by `plugins.zsh` (in order):

1. [`zsh-autosuggestions`](https://github.com/zsh-users/zsh-autosuggestions) — fish-style inline suggestions
2. [`zsh-history-substring-search`](https://github.com/zsh-users/zsh-history-substring-search) — ↑/↓ substring history search
3. [`zsh-vi-mode`](https://github.com/jeffreytse/zsh-vi-mode) — modal vi keybindings
4. [`fast-syntax-highlighting`](https://github.com/zdharma-continuum/fast-syntax-highlighting) — command-line syntax highlighting

#### Startup load order

zsh reads its startup files in a fixed order. With `ZDOTDIR` set, ours load like this:

```
1. /etc/zshenv                    (system, if present)
2. ~/.zshenv                      → sets ZDOTDIR, then sources:
     └─ ~/.config/zsh/.zshenv     (environment: XDG, PATH incl. nvm node, ...)
   (login)  /etc/zprofile         → macOS path_helper reorders PATH
            ~/.config/zsh/.zprofile  → re-prepends nvm node after path_helper
3. ~/.config/zsh/.zshrc           (interactive shells) sources, in order:
     ├─ fzf.zsh
     ├─ aliases.zsh
     ├─ bindings.zsh   ← defines zvm_after_init BEFORE plugins load
     ├─ plugins.zsh    ← zsh-vi-mode resets keymaps, then runs zvm_after_init
     └─ prompt.zsh     ← starship (last, so it owns the prompt)
   (login)  /etc/zlogin, ~/.config/zsh/.zlogin        — not used here
```

Why the order matters:
- **`.zshenv` runs for every shell** (including non-interactive scripts), so it holds only environment/`PATH` — nothing interactive.
- **`.zshrc` runs only for interactive shells** — aliases, keybindings, prompt.
- **`bindings.zsh` is sourced before `plugins.zsh`** because `zsh-vi-mode` clears keymaps on init and only re-applies custom bindings registered via the `zvm_after_init` hook.
- **`prompt.zsh` is sourced last** so Starship initializes after any plugin that could touch the prompt.

#### node / nvm on PATH

Node is managed by [nvm](https://github.com/nvm-sh/nvm), but nvm's own
`node`/`npm`/`npx` only land on `PATH` after `nvm.sh` is sourced — and `nvm.sh`
is slow (100 ms+) and is only sourced from `.zshrc`, i.e. **interactive shells
only**. That meant non-interactive tools (scripts, editors, AI coding agents
like Claude Code) fell back to a *different* node (e.g. `/usr/local/bin/node`)
with none of your nvm-installed global packages.

To fix this without paying nvm's startup cost, `.zshenv` resolves nvm's
**default** node version and prepends its `bin` directory to `PATH` directly:

```bash
export NVM_DIR="$HOME/.config/nvm"
# ...resolve the default version, then add
# "$NVM_DIR/versions/node/<ver>/bin" to PATH
```

Because `.zshenv` is read by **every** zsh invocation, all shells — interactive,
non-interactive, login, and non-login — now use the same node. The `nvm`
*command* itself stays lazy-loaded in `.zshrc` (a one-line function that sources
`nvm.sh` on first use), since you only need it occasionally for `nvm use` /
`nvm install`. `uv` is a fast standalone binary already on `PATH`, so `.zshrc`
just loads its completion eagerly — no wrapper needed.

**macOS login-shell caveat.** On macOS, `/etc/zprofile` runs `path_helper`,
which rebuilds `PATH` *after* `.zshenv` and pushes system dirs like
`/usr/local/bin` back to the front. `~/.config/zsh/.zprofile` runs after that
and re-prepends nvm's node, so login shells stay consistent too.

**How do I know which shell type a tool (e.g. Claude Code) uses?** The pragmatic
test is to just run this inside the tool's shell:

```bash
command -v node   # nvm path = good; /usr/local/bin/node = wrong node
```

To inspect the shell mode explicitly (works in zsh or bash):

```bash
# zsh
[[ -o login ]] && echo login || echo non-login
[[ -o interactive ]] && echo interactive || echo non-interactive
# bash
shopt -q login_shell && echo login || echo non-login
case $- in *i*) echo interactive;; *) echo non-interactive;; esac
```

With the setup above, `node` resolves to nvm's version in **all** of those
modes, so it shouldn't matter — but this is how you'd confirm.

## 🤖 Claude Code — multiple accounts

Run two Claude Code accounts (e.g. work + personal) on one machine without them
colliding. Claude Code ties all of an account's state to a single config
directory, selectable via the `CLAUDE_CONFIG_DIR` environment variable
([technique reference](https://frontendhire.com/learn/ai/courses/using-multiple-claude-accounts/overview)).

Two aliases (in both `zsh` and `fish`) point Claude at per-account dirs:

```bash
claude-work       # CLAUDE_CONFIG_DIR=~/.claude-work claude
claude-personal   # CLAUDE_CONFIG_DIR=~/.claude-personal claude
```

**What's isolated vs shared.** Each dir keeps its own login (on macOS the login
lives in the Keychain, keyed per config dir), `history.jsonl`, `projects/`, and
`sessions/`. Shared, read-mostly config is **symlinked** from `~/.claude` into
each account dir so there's a single source of truth:

```
~/.claude-work/skills   -> ~/.claude/skills
~/.claude-work/agents   -> ~/.claude/agents
~/.claude-work/commands -> ~/.claude/commands
# ...also: settings.json, statusline.cjs, hooks, output-styles, rules,
#          schemas, scripts, plugins, CLAUDE.md
```

`bootstrap.sh` creates the dirs and symlinks automatically (guarded on
`~/.claude` existing). To set it up manually or on another machine:

```bash
for dir in ~/.claude-work ~/.claude-personal; do
  mkdir -p "$dir"
  for item in CLAUDE.md settings.json statusline.cjs agents commands hooks \
              output-styles rules schemas scripts skills plugins workflows; do
    [ -e ~/.claude/"$item" ] && ln -sfn ~/.claude/"$item" "$dir/$item"
  done
done
```

### Installing skills with claudekit-cli (`ck`)

[`claudekit-cli`](https://github.com/mrgoonie/claudekit-cli) (`ck`) installs
global skills/commands/agents to `$CLAUDE_CONFIG_DIR` if set, otherwise to
`~/.claude` (verified against its `PathResolver.getGlobalKitDir()`). Since the
`claude-work`/`claude-personal` aliases only export `CLAUDE_CONFIG_DIR` for the
`claude` process, a plain terminal leaves it unset — so **`ck` installs to
`~/.claude`, and the symlinks above propagate everything to both accounts
automatically**. Install once, no per-account runs:

```bash
ck init -g   # writes to ~/.claude → both accounts see it via the symlinks
ck skills
```

Cautions:
- **Don't run `ck` from inside a `claude-work`/`claude-personal` session** — there `CLAUDE_CONFIG_DIR` is exported, so `ck` would target the account dir instead of `~/.claude`. Use a plain terminal.
- **Don't run `ck init --fresh` / `ck uninstall` with `CLAUDE_CONFIG_DIR` pointed at an account dir** — those delete config subdirs and could recurse through the symlinks into your real `~/.claude`. Run them against `~/.claude`.
- If `ck` ever adds a **new** top-level dir (e.g. `workflows/`), re-run the seeding snippet above to symlink it into the account dirs.

**First-time login** — run each alias once and sign in with the matching
account:

```bash
claude-work       # then: /login  (work account)
claude-personal   # then: /login  (personal account)
```

After that, each alias remembers its own login. Use the alias that matches the
repo you're in.

## 🚀 Usage

### Install everything
```bash
./bootstrap.sh
```

### Preview / apply changes
```bash
chezmoi diff              # See what would change in $HOME
chezmoi apply             # Apply changes
chezmoi apply --dry-run -v
```

### Edit a managed file
```bash
chezmoi edit ~/.config/zsh/.zshrc   # edits the source under home/, then run chezmoi apply
```

### Start managing a new file
```bash
chezmoi add ~/.config/newapp/config
chezmoi add --template ~/.config/app/secret.conf   # add as a template
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

## 📋 Managed Configurations

**20 application configs** managed by chezmoi, organized by category:

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

| Config | Description |
|--------|-------------|
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
| **zsh** | Modular Zsh config under `~/.config/zsh` (ZDOTDIR) with a self-contained plugin manager |

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
git pull         # auto-applies via git hook (see below)
# or, to also refresh tools/packages:
./bootstrap.sh
```

### Auto-apply git hooks

A `git pull` in this repo automatically runs `chezmoi apply`, so updates
propagate to `$HOME` without a manual step. Tracked hooks live in `.githooks/`:

- `post-merge` — fires after a merge-style pull.
- `post-rewrite` — fires after a rebase-style pull (this repo sets
  `pull.rebase = true`, so pulls rebase and would otherwise skip `post-merge`).
  It only runs for rebases, not `git commit --amend`.

Both are no-ops if `chezmoi` isn't installed. They're enabled by pointing git at
the tracked hooks directory:

```bash
git config core.hooksPath .githooks
```

`bootstrap.sh` runs this automatically, so a fresh clone is wired up after the
first bootstrap. Because `core.hooksPath` lives in the local (uncommitted)
`.git/config`, each new clone needs bootstrap (or the command above) once. If you
ever want to apply manually instead, just run `chezmoi apply`.

## 🛠️ Customization

### Adding new config
```bash
chezmoi add ~/.config/newapp/config   # copies into home/ with correct naming
```
Then commit the new files under `home/` and push.

### Modifying existing configs
```bash
chezmoi edit ~/.config/zsh/.zshrc   # edit the source under home/
chezmoi apply                       # write changes to $HOME
```
Note: unlike stow, chezmoi does **not** use symlinks — it writes real files to
`$HOME`. Always edit the source (via `chezmoi edit` or directly in `home/`) and
run `chezmoi apply`, not the target files.

### Ignoring files
Add target-path patterns to `home/.chezmoiignore` (gitignore syntax) for
per-machine state that should never be applied.

## 🆘 Troubleshooting

### Adopt existing $HOME files into the repo
```bash
chezmoi add ~/.config/nvim   # import current files as the new source of truth
```

### See exactly what will change
```bash
chezmoi diff
chezmoi apply --dry-run -v
```

### Secret/template errors (e.g. WakaTime)
```bash
eval "$(op signin)"   # sign in to 1Password CLI
chezmoi apply         # re-render templates
```

### Verify chezmoi's state
```bash
chezmoi doctor        # diagnose configuration/tooling issues
chezmoi managed       # list managed files
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