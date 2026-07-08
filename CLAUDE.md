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
- **Shell**: Zsh (default) — modular XDG config under `~/.config/zsh` (`ZDOTDIR`), bootstrapped by a minimal `~/.zshenv`, with a self-contained git-clone plugin manager (no zinit) + Starship prompt
- **Alt Shell**: Fish + Fisher plugin manager (still fully configured; launch with `fish`)
- **Window Management**: AeroSpace + JankyBorders + SketchyBar
- **Git**: 1Password SSH signing, conditional includes for `~/ws/work/` vs `~/ws/personal/`
- **Node.js**: nvm (`~/.config/nvm`). `.zshenv` prepends nvm's default node `bin` to `PATH` so `node`/`npm`/`npx` work in **all** shells (interactive, non-interactive, login, non-login) — important for tools/agents that shell out non-interactively. `~/.config/zsh/.zprofile` re-prepends it after macOS `path_helper` in login shells. The `nvm` command itself is lazy-loaded in `.zshrc`.
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

### Auto-apply Git Hooks
Tracked hooks in `.githooks/` run `chezmoi apply` automatically after a `git pull`:
- `post-merge` → fires on merge-style pulls.
- `post-rewrite` → fires on rebase-style pulls (this repo sets `pull.rebase = true`, so pulls rebase and skip `post-merge`); guarded to run only for `rebase`, not `git commit --amend`.

Both no-op if `chezmoi` is absent. They're activated via `git config core.hooksPath .githooks`, which `bootstrap.sh` sets. Since `core.hooksPath` lives in the local `.git/config` (not committed), each fresh clone needs bootstrap (or that command) once.
