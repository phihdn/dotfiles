# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

macOS dotfiles managed with [chezmoi](https://www.chezmoi.io). This repository is the chezmoi **source directory**. A `.chezmoiroot` file at the repo root contains `home`, so chezmoi uses the `home/` subdirectory as the effective source. Everything else at the repo root (`README.md`, `Brewfile`, `bootstrap.sh`, `CLAUDE.md`) is repo tooling, not applied to `$HOME`.

## Commands

```bash
# Full bootstrap (from repo root) — installs tools + applies dotfiles
./bootstrap.sh

# chezmoi (after bootstrap sets sourceDir to this repo)
chezmoi diff                 # Preview pending changes
chezmoi apply                # Apply changes to $HOME
chezmoi apply --dry-run -v   # Dry run
chezmoi edit ~/.zshrc        # Edit the source of a managed file
chezmoi add ~/.config/foo    # Start managing a new file/dir
chezmoi managed              # List everything chezmoi manages
chezmoi cd                   # Open a shell in the source directory

# Homebrew sync (custom script at ~/.local/bin/brew-sync)
brew-sync                    # Install + prompt cleanup
brew-sync preview            # Show removable packages
brew-sync force              # Full sync, no prompts
```

## Architecture

### Source Layout
- `.chezmoiroot` (repo root) → contains `home`; makes `home/` the effective source dir.
- `home/` mirrors `$HOME` using chezmoi naming conventions:
  - `dot_config/` → `~/.config/`, `dot_zshrc` → `~/.zshrc`, `dot_gitconfig` → `~/.gitconfig`
  - `executable_<name>` → sets the executable bit (e.g. `home/dot_local/bin/executable_brew-sync` → `~/.local/bin/brew-sync`)
  - `private_<name>` → mode `0600`
  - `<name>.tmpl` → rendered as a Go text/template
- `home/.chezmoiignore` → target paths chezmoi must never manage (per-machine state).

### Key Integrations
- **Shell**: Fish (default) + Fisher plugin manager + Starship prompt
- **Alt Shell**: Zsh + Zinit available as fallback
- **Window Management**: AeroSpace + JankyBorders + SketchyBar
- **Git**: 1Password SSH signing, conditional includes for `~/ws/work/` vs `~/ws/personal/`
- **Node.js**: nvm (`~/.config/nvm`)
- **Python**: uv for package/version management

### Secrets
Secrets are resolved at `chezmoi apply` time via the 1Password CLI template function. Example: `home/private_dot_wakatime.cfg.tmpl` renders `~/.wakatime.cfg` using `{{ onepasswordRead "op://Personal/WakaTime/api_key" }}`. Requires `op` to be signed in.

### Adding New Files
```bash
chezmoi add ~/.config/newapp/config      # chezmoi copies it into home/ with correct naming
chezmoi add --template ~/.some.secret    # add as a template
```
Then commit the resulting files under `home/`.

### chezmoi Source Directory
After `bootstrap.sh`, `~/.config/chezmoi/chezmoi.toml` sets `sourceDir` to this repo, so bare `chezmoi` commands operate on this checkout directly (edit here, then `chezmoi apply`).
