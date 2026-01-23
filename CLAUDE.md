# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

macOS dotfiles managed with GNU Stow. Each subdirectory under `dotfiles/` is a "package" that mirrors the target filesystem structure from `$HOME`.

## Commands

```bash
# Full bootstrap (from repo root)
./bootstrap.sh

# GNU Stow operations (run from repo root)
stow --target=$HOME --dir=./dotfiles nvim      # Install package
stow -D --target=$HOME --dir=./dotfiles nvim   # Remove package
stow -n -v --target=$HOME --dir=./dotfiles nvim  # Dry run

# Homebrew sync (custom script at ~/.local/bin/brew-sync)
brew-sync          # Install + prompt cleanup
brew-sync preview  # Show removable packages
brew-sync force    # Full sync, no prompts
```

## Architecture

### Package Structure
- Files in `dotfiles/<pkg>/` symlink to `$HOME/<same-path>`
- XDG-compliant configs use `dotfiles/<pkg>/.config/<app>/` structure
- `PACKAGES` array in `bootstrap.sh` defines install order

### Key Integrations
- **Shell**: Zsh + Zinit plugin manager + Starship prompt
- **Window Management**: AeroSpace + JankyBorders + SketchyBar
- **Git**: 1Password SSH signing, conditional includes for `~/ws/work/` vs `~/ws/personal/`
- **Node.js**: nvm at `~/.config/nvm` (non-standard XDG location)
- **Python**: uv for package/version management

### Secrets
1Password injection for sensitive configs: `wakatime.cfg.tpl` → `.wakatime.cfg` via `op inject`.

### Adding New Packages
1. Create `dotfiles/<package-name>/` mirroring target structure
2. Add package name to `PACKAGES` array in `bootstrap.sh`
3. Run `stow --target=$HOME --dir=./dotfiles <package-name>`

### Stow Ignore
`.stow-global-ignore` excludes: `.tpl`, `.template`, `README.*`, `.git`, `.DS_Store`, editor files.
