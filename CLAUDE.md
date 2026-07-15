# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

Cross-platform (macOS + Linux) dotfiles managed with [chezmoi](https://www.chezmoi.io). **Every change must work on both OSes**: guard macOS-only parts with `uname` checks in scripts, `if OS.mac?` in the Brewfile, and `{{ if eq .chezmoi.os "darwin" }}` in chezmoi templates / `.chezmoiignore` (macOS-only app configs like AeroSpace/SketchyBar/JankyBorders are ignored on Linux there). Shells detect the Homebrew prefix at runtime via `HOMEBREW_PREFIX` — never hardcode `/opt/homebrew`. This repository is the chezmoi **source directory**. A `.chezmoiroot` file at the repo root contains `home`, so chezmoi uses the `home/` subdirectory as the effective source. Everything else at the repo root (`README.md`, `Brewfile`, `bootstrap.sh`, `CLAUDE.md`) is repo tooling, not applied to `$HOME`.

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
- **Claude Code (multi-account)**: `claude-work` / `claude-personal` aliases (zsh + fish) set `CLAUDE_CONFIG_DIR` to `~/.claude-work` / `~/.claude-personal` so logins/history/projects/sessions are isolated. Shared config (skills, agents, commands, settings, hooks, ...) is symlinked from `~/.claude`; `bootstrap.sh` creates the dirs + symlinks (guarded on `~/.claude` existing). `AgentKit` (`ak`, formerly `claudekit-cli`/`ck`) installs globally to `$CLAUDE_CONFIG_DIR` or, unset, `~/.claude` — so run `ak` from a plain terminal (not inside a `claude-*` session) and the symlinks propagate skills to both accounts; avoid `ak uninstall` against an account dir.
- **`~/.claude` backup (separate PRIVATE repo)**: `~/.claude` is **not** managed by this public repo — it holds the paid AgentKit kit. It lives in its own private repo (`git@github.com:phihdn/dotfiles-claude.git`), which commits the ak layer + custom `CLAUDE.md`/`rules/markdown-formatting.md`/`settings.json`/`agent-memory/` and gitignores all secrets/state (`.env`, `history.jsonl`, `projects/`, `sessions/`, `cache/`, `telemetry/`, `plugins/`, ...). `bootstrap.sh` clones it into `~/.claude` (before the account-symlink step) and runs `ak kit refresh core|engineer|marketing --yes` to bring the ak layer to latest. Not a submodule. Author your own items with a `phi-` prefix so they survive `ak kit refresh`.

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
