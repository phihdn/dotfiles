# 🛠️ dotfiles

A terminal-first, keyboard-driven development environment for **macOS and Linux**, managed declaratively with [chezmoi](https://www.chezmoi.io) and themed [Catppuccin Mocha](https://github.com/catppuccin/catppuccin) end to end.

_Started from [NLaundry/MacAutoSetup](https://github.com/NLaundry/MacAutoSetup); long since its own thing._

## ✨ Highlights

- 🖋️ **chezmoi** — one repo mirrors `$HOME`; templates pull secrets from 1Password at apply time, `git pull` auto-applies through tracked hooks.
- 🚀 **Zsh** — default shell with a modular XDG config under `~/.config/zsh` and a self-contained git-clone plugin manager; **Fish** stays fully configured as an alternative.
- 🧑‍💻 **Neovim** — self-maintained config on nvim 0.11+ native LSP, fzf-lua and mini.nvim; LazyVim kept as a fallback profile (`nvl`).
- 🪟 **tmux** — [sesh](https://github.com/joshmedeski/sesh) sessions with path-aware layouts, and a status bar in the [tokyo-night-tmux](https://github.com/janoamaral/tokyo-night-tmux) layout that never forks a process to redraw — a background daemon feeds it, including live **Claude Code session state** per window.
- 🌳 **Git worktrees** — `git bare-clone` + `git wt` for a one-directory-per-branch workflow (fixed `develop`/`prod` checkouts, ephemeral task and detached review worktrees).
- 🤖 **Claude Code, two accounts** — `claude-work` / `claude-personal` keep logins and history apart while sharing one set of skills, hooks and settings.
- 🪟 **AeroSpace** tiling, **Raycast**, **1Password** SSH agent + commit signing, **Starship** prompt, and the usual modern CLI (ripgrep, fzf, fd, bat, lsd, zoxide, lazygit, k9s …).

## 🚀 Installation

```bash
git clone git@github.com:phihdn/dotfiles.git ~/dotfiles
cd ~/dotfiles
./bootstrap.sh
```

`bootstrap.sh` is idempotent and does, in order:

1. Prerequisites — Xcode CLI tools on macOS; on Linux it checks for `curl`/`git`/`gcc` instead (install `build-essential` or equivalent first).
2. Homebrew (macOS or Linuxbrew), then everything in the `Brewfile` — including chezmoi.
3. Points chezmoi's `sourceDir` at this checkout, enables the auto-apply git hooks (`core.hooksPath .githooks`), and runs `chezmoi apply`.
4. Shell environment — tpm (tmux plugin manager), nvm into `~/.config/nvm`, uv.
5. Sets zsh as the default shell (fish stays available via `fish`) and generates kubectl completions for fish.
6. Claude Code — clones the private `~/.claude` backup and seeds the `~/.claude-work` / `~/.claude-personal` account dirs (see [Claude Code — multiple accounts](#-claude-code--multiple-accounts)).

Secrets (the WakaTime API key, the work git identity) are rendered from 1Password at apply time. Until the `op` CLI has an account configured, `.chezmoiignore` skips the secret-bearing targets (`~/.wakatime.cfg`, `~/.gitconfig-work`) so a fresh machine applies cleanly — set up `op`, then re-run `chezmoi apply` to create them.

Afterwards, open a new terminal (or `exec zsh -l`) and press `prefix+I` inside tmux once to install the tmux plugins.

### 🐧 Linux support

Every change here must work on both OSes. `bootstrap.sh` detects the OS, installs Homebrew to `/home/linuxbrew/.linuxbrew` on Linux and falls back to the system zsh for the default shell. OS-specific handling:

- **Brewfile** — casks and mac-only formulae are wrapped in `if OS.mac?`; on Linux install GUI apps and Nerd Fonts via your distro/Flatpak.
- **chezmoi templates** — `~/.gitconfig*` pick the right 1Password `op-ssh-sign` path per OS (`/opt/1Password/op-ssh-sign` on Linux), and `home/.chezmoiignore` skips macOS-only app configs (AeroSpace, Karabiner) on Linux.
- **Shells** — zsh and fish detect the Homebrew prefix at runtime (`HOMEBREW_PREFIX`), so PATH works with macOS arm64/Intel brew and Linuxbrew. Never hardcode `/opt/homebrew`.
- **Scripts** — anything macOS-specific is guarded on `uname` (e.g. `tmux-sysinfo` reads `host_statistics64` on macOS and `/proc/stat` on Linux).

## 📦 What the Brewfile installs

Plain `brew` formulae install on both OSes; casks and fonts are macOS-only.

| Group | Packages |
| --- | --- |
| Core CLI | git, curl, wget, chezmoi, fzf, ripgrep, bat, fd, jq, yq, gh, glab, htop, neofetch; GNU coreutils/sed/findutils/gawk on macOS |
| Editor & git | neovim (HEAD), tree-sitter-cli, lazygit, git-delta, difftastic, tuicr, git-lfs, gitmux |
| Terminal | tmux, sesh, zsh, fish, starship, zoxide, lf, lsd, gum |
| Containers & cloud | lazydocker, lazysql, kubectl, k9s, k3sup, helm, ansible, awscli, gcloud-cli (cask), tailscale |
| Languages | go, rust, bun, uv (Node comes from nvm, installed by `bootstrap.sh`) |
| Utilities | mosh, nmap, cloc, tz, witr, speedtest, crush, libpq (psql without the server) |
| GUI (macOS) | AeroSpace, Raycast, 1Password + CLI, Claude Desktop, Claude Code, Visual Studio Code, Rancher Desktop, Postman, Bruno, WezTerm, Ghostty, Kitty, Google Chrome, Discord, Zoom, OBS, Obsidian, Calibre, Audacity, NetNewsWire, Itsycal, KeyCastr, balenaEtcher |
| Fonts (macOS) | JetBrains Mono, Fira Code and Hack Nerd Fonts |

Ghostty's config asks for **CommitMono Nerd Font**, which is not in the Brewfile — install it separately or change `font-family` in `home/dot_config/ghostty/config`. Any Nerd Font works for the tmux bar; it only uses Nerd Font (MDI/FA) code points, never the "legacy computing" block.

`brew-sync` keeps the machine and the Brewfile in step:

```bash
brew-sync            # install missing + prompt to remove packages not in Brewfile
brew-sync preview    # show what cleanup would remove
brew-sync install    # install only
brew-sync cleanup    # cleanup only
brew-sync force      # full sync, no prompts
```

## 📁 Repository layout

This repository is the chezmoi **source directory**. `.chezmoiroot` contains `home`, so chezmoi applies `home/` to `$HOME`; everything else at the root (`Brewfile`, `bootstrap.sh`, `CLAUDE.md`, `docs/`, `plans/`) is repo tooling, not applied.

```text
.
├── .chezmoiroot        # contains "home" → chezmoi source is home/
├── .githooks/          # post-merge + post-rewrite → chezmoi apply after git pull
├── Brewfile            # Homebrew packages (macOS + Linux)
├── bootstrap.sh        # installer
├── docs/               # longer write-ups (git worktree workflow, journals)
└── home/               # chezmoi source (mirrors $HOME)
    ├── .chezmoiignore                  targets chezmoi must never manage (per-machine state, OS-conditional)
    ├── .chezmoiremove                  targets chezmoi deletes if present (the old monolithic ~/.zshrc)
    ├── dot_zshenv                    → ~/.zshenv                zsh bootstrap (points ZDOTDIR at ~/.config/zsh)
    ├── dot_gitconfig.tmpl            → ~/.gitconfig             identity, 1Password SSH signing, conditional includes
    ├── dot_gitconfig-personal.tmpl   → ~/.gitconfig-personal    included for repos under ~/ws/personal/
    ├── private_dot_gitconfig-work.tmpl → ~/.gitconfig-work      included for repos under ~/ws/work/ (from 1Password, 0600)
    ├── private_dot_wakatime.cfg.tmpl → ~/.wakatime.cfg          WakaTime (API key from 1Password, 0600)
    ├── dot_markdownlint-cli2.jsonc   → ~/.markdownlint-cli2.jsonc  markdownlint defaults nvim uses
    ├── dot_local/bin/executable_*    → ~/.local/bin/*           user scripts (see below)
    └── dot_config/                   → ~/.config/
        ├── zsh/            modular zsh config (see "zsh configuration")
        ├── fish/           fish config (config.fish, conf.d/, functions/)
        ├── nvim/           Neovim — self-maintained config
        ├── nvim-lazyvim/   Neovim — LazyVim fallback profile (`nvl`)
        ├── tmux/           tmux.conf + gitmux.conf
        ├── sesh/           sesh sessions + reusable window definitions
        ├── starship.toml   prompt (shared by zsh and fish)
        ├── aerospace/      tiling window manager (macOS)
        ├── private_karabiner/  Karabiner-Elements (macOS)
        ├── ghostty/ kitty/ wezterm/   terminal emulators
        ├── bat/ lsd/ lf/ lazygit/ k9s/ neofetch/   CLI tool configs + Catppuccin themes
        └── 1Password/ssh/agent.toml   1Password SSH agent
```

chezmoi's file-name prefixes encode attributes:

| Source name | Target | Meaning |
| --- | --- | --- |
| `dot_config/` | `~/.config/` | leading dot |
| `executable_foo` | `~/foo` (`+x`) | executable bit |
| `private_foo` | `~/foo` (`0600`) | restricted permissions |
| `foo.tmpl` | `~/foo` | Go template (secrets, OS conditionals) |

### Scripts in `~/.local/bin`

| Script | Purpose |
| --- | --- |
| `brew-sync` | Reconcile installed Homebrew packages with the Brewfile |
| `git-bare-clone`, `git-wt` | Bare-clone + worktree workflow, reached as `git bare-clone` / `git wt` |
| `lg` | lazygit, aware of the bare-repo worktree layout; behind `prefix+g` in tmux |
| `sesh_start`, `sesh-dev-layout` | sesh session picker (`s` alias) and the nvim-over-shell pane layout for the `dev` window |
| `tmux-session-layout` | `session-created` hook: two-window layout for worktree sessions under `~/ws/` |
| `tmux-status-daemon` | Background feeder for the status bar (git, cpu/mem, uptime, window glyphs) |
| `tmux-claude-status` | Claude Code hook receiver → per-window Claude state + session count on the bar |
| `tmux-sysinfo`, `tmux-uptime`, `icons` | Segment producers the daemon calls |
| `echo-path.sh`, `testfont.sh` | Print `PATH` one entry per line; print Nerd Font glyph ranges to check a font |

## 🐚 zsh configuration (`~/.config/zsh`, `ZDOTDIR`)

The zsh config is split into small, single-purpose modules. `~/.zshenv` is the only zsh file kept in `$HOME`; it sets `ZDOTDIR` to `~/.config/zsh` so every other file lives there and `$HOME` stays clean.

| File | Purpose |
| --- | --- |
| `~/.zshenv` (`dot_zshenv`) | Minimal bootstrap. Sets `XDG_CONFIG_HOME` and `ZDOTDIR=~/.config/zsh`, then sources `$ZDOTDIR/.zshenv`. Read by **every** zsh invocation. |
| `.zshenv` | Environment for all shells: XDG dirs, `EDITOR`/`VISUAL=nvim`, `MANPAGER=bat`, `GPG_TTY`, `KUBECONFIG`, `K9S_CONFIG_DIR`, and a deduplicated `PATH` (including nvm's default node — see below). |
| `.zprofile` | Login shells only. Re-prepends nvm's node to `PATH` after macOS `path_helper` reorders it. |
| `.zshrc` | Interactive setup: history, shell options, completion (`compinit`), `zoxide`, fzf key-bindings, `kubectl` completion, lazy `nvm` + `uv` completion, then sources the modules below. |
| `fzf.zsh` | fzf defaults (`fd` source, `bat` preview, UI options) and the `Ctrl-F` file-picker widget. |
| `aliases.zsh` | Aliases (git, kubernetes, `lsd`, `bat`, `rg`, `v`=nvim, `s`=sesh picker, `gwt`, `claude-work`/`claude-personal`) and helper functions (`lf` dir-follow). |
| `bindings.zsh` | Key-bindings and vi-mode cursor settings. Defines the `zvm_after_init` hook **before** plugins load so custom bindings survive zsh-vi-mode's reset. |
| `plugins.zsh` | Self-contained plugin manager: clones plugins into `~/.config/zsh/plugins` on first launch and sources them. Run `zplugin-update` to update. |
| `prompt.zsh` | Initializes the Starship prompt (or a minimal `$` prompt inside Cursor Agent). |
| `local.zsh` | **Optional, per-machine, not managed by chezmoi.** Sourced last by `.zshrc` if it exists — machine-specific exports and secrets go here; it never lands in this repo. |

Plugins loaded by `plugins.zsh`, in order: [`zsh-autosuggestions`](https://github.com/zsh-users/zsh-autosuggestions), [`zsh-history-substring-search`](https://github.com/zsh-users/zsh-history-substring-search), [`zsh-vi-mode`](https://github.com/jeffreytse/zsh-vi-mode), [`fast-syntax-highlighting`](https://github.com/zdharma-continuum/fast-syntax-highlighting).

### Startup load order

```text
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
```

Why the order matters: `.zshenv` runs for every shell (including non-interactive scripts), so it holds only environment and `PATH`; `.zshrc` runs only for interactive shells; `bindings.zsh` comes before `plugins.zsh` because `zsh-vi-mode` clears keymaps on init and only re-applies bindings registered through `zvm_after_init`; `prompt.zsh` is last so Starship initializes after anything that could touch the prompt.

### node / nvm on PATH

Node is managed by [nvm](https://github.com/nvm-sh/nvm) (`NVM_DIR=~/.config/nvm`), but nvm's `node`/`npm`/`npx` only land on `PATH` after `nvm.sh` is sourced — and `nvm.sh` is slow (100 ms+) and only sourced from `.zshrc`, i.e. interactive shells. That left non-interactive tools (scripts, editors, AI coding agents) with a _different_ node and none of the nvm-installed globals.

`.zshenv` therefore resolves nvm's **default** version and prepends its `bin` directory to `PATH` directly, without loading nvm. Because `.zshenv` is read by every zsh invocation, all shells — interactive, non-interactive, login, non-login — use the same node. The `nvm` command itself stays lazy-loaded in `.zshrc` (a one-line function that sources `nvm.sh` on first use). On macOS, `/etc/zprofile` runs `path_helper` after `.zshenv` and pushes `/usr/local/bin` back to the front, so `~/.config/zsh/.zprofile` re-prepends nvm's node for login shells too.

To confirm from inside any tool's shell: `command -v node` should print a path under `~/.config/nvm/versions/node/`.

Day-to-day: `nvm install --lts`, `nvm alias default <version>`, `.nvmrc` per project. Python is managed by [uv](https://docs.astral.sh/uv/) (`uv python install`, `uv init`, `uv add`, `uv run`, `uv tool install`) — a standalone binary already on `PATH`, so `.zshrc` only loads its completion.

## 🧑‍💻 Neovim

`~/.config/nvim` is a self-maintained config (custom Lua under `lua/phihdn/{core,plugins}`, one plugin per file), modernized for nvim 0.11+: native `vim.lsp.config()`/`vim.lsp.enable()` (mason installs the binaries; no mason-lspconfig), treesitter `main` branch, fzf-lua as the sole picker, blink.cmp completion, conform + nvim-lint, catppuccin (Mocha), oil + mini.files for file management, and mini.ai/mini.surround textobjects. Languages: go, typescript, python (basedpyright), lua, bash, yaml, postgres, markdown.

`lazy-lock.json` **is committed** for this config — the applied target is the source of truth, so after `:Lazy update`, copy it back before committing: `cp ~/.config/nvim/lazy-lock.json home/dot_config/nvim/`.

**LazyVim fallback**: the LazyVim setup used during 2026-07 is kept fully working at `home/dot_config/nvim-lazyvim/` under an isolated `NVIM_APPNAME=nvim-lazyvim` profile — run it with the `nvl` alias (zsh + fish). Its lockfile stays unmanaged (see `.chezmoiignore`). History snapshots: [`20260710-nvim-pre-lazyvim`](https://github.com/phihdn/dotfiles/tree/20260710-nvim-pre-lazyvim/home/dot_config/nvim) (self config before the LazyVim experiment) and `20260730-nvim-pre-self` (LazyVim as main, right before the swap).

## 🪟 tmux

Default `prefix+b` and default keybindings, plus a few additions (all listed by `prefix+?`): vim-style `Ctrl-h/j/k/l` pane movement that passes through to nvim splits, `prefix+h/j/k/l` and `prefix+C-h/C-l` for panes and windows, `prefix+N/P` to swap a window right/left, `prefix+Space` to toggle the last window, `prefix+u` to pick a URL from the pane with fzf, `prefix+g` for lazygit in a popup, `prefix+r` to reload the config, and `prefix+K` / `prefix+L` for the sesh picker and the last session.

### Status bar

The layout follows [tokyo-night-tmux](https://github.com/janoamaral/tokyo-night-tmux), rebuilt in the Mocha palette rather than installed as a plugin — that plugin renders every widget through `#()` shell-outs (including one per window per refresh just to draw the stylised digits), which is exactly the cost this bar is built to avoid.

Left to right:

| Segment | What it shows |
| --- | --- |
| Session | Session name, bold dark text on a solid blue block with a dimmed 󰤂 icon. Holding the prefix turns the block red and the icon to 󰠠. |
| Tabs | `glyph  index  name`: the program's Nerd Font glyph, the window index as a filled square (󰎤 󰎧 …), the window name, plus 󰊓 when a pane is zoomed. The active tab is bold on a surface0 block; the previously used window is flagged 󰁯 in yellow. The glyph turns **blue while that window's Claude Code is working and a red block while it waits on you**. |
| Path | `░` + the current directory's basename (last 24 chars). |
| Git | `▒` block + state icon, colored green (synced), peach (dirty), red (ahead — push), mauve (behind), followed by gitmux's counts and branch. Hidden outside a repo. |
| Claude | `░` + number of live Claude Code sessions, a red block while any of them waits on you. Hidden when none run. |
| CPU / RAM | `░` + both as percentages; RAM turns a red block past `TMUX_SYSINFO_MEM_ALERT` (85%). |
| Uptime | `░ ⏻` + uptime; a red block once the machine has been up over 7 days. |
| Clock | `YYYY-MM-DD ❬ HH:MM` on a surface0 block. |

#### Fork-free rendering (`tmux-status-daemon`)

The status formats contain **no `#()` subshells**. tmux forks a process per `#()` per refresh, for every window's format too, and any subshell in the status line also makes redraws slow down with scrollback size ([tmux/tmux#3352](https://github.com/tmux/tmux/issues/3352)) — on a loaded machine the bar visibly stalled. Instead `tmux-status-daemon` runs once per server (started from `tmux.conf` with `run-shell -b`, guarded by `@status_daemon_pid` so a config reload does not start a second one) and every 15s pushes each dynamic segment into a tmux user option that the formats read natively:

| Option | Scope | Content |
| --- | --- | --- |
| `@status_sysinfo`, `@status_uptime` | global | pre-styled output of `tmux-sysinfo` / `tmux-uptime` |
| `@status_git` | session | gitmux for the session's active pane, wrapped in the state block |
| `@win_icon` | window | glyph from `icons <pane_current_command>` |
| `@win_claude`, `@status_claude` | window / global | Claude state (see below) |

Only **attached** sessions are refreshed — sesh keeps dozens open, and nothing renders the others. Three hooks (`after-select-window`, `client-session-changed`, `session-created`) call `tmux-status-daemon refresh-focus` so the git segment follows a window or session switch immediately instead of waiting out the tick. Machine load can now only delay the numbers, never the redraw. Window and pane indexes become glyphs through native `#{?#{==:#I,n},…}` conditionals rather than a script.

After editing any of the daemon's scripts, restart it — `chezmoi apply` plus a config reload is not enough, because the running loop keeps ownership:

```bash
kill "$(tmux show -gqv @status_daemon_pid)"; tmux set -gu @status_daemon_pid
tmux source-file ~/.config/tmux/tmux.conf
```

#### Claude Code session status (`tmux-claude-status`)

Claude Code hooks in `~/.claude/settings.json` (the private repo, see below) pipe their events into `tmux-claude-status hook` for `SessionStart`, `UserPromptSubmit`, `PreToolUse` (AskUserQuestion), `Notification` (permission_prompt), `PostToolUse`, `Stop` and `SessionEnd`. Each session's state — `working`, `attention`, `idle` — plus its tmux pane id is kept in `$TMPDIR/tmux-claude-status.<uid>/<session_id>`; `render` (called by every hook and by the daemon tick) folds those into `@win_claude` per window and the `@status_claude` count.

Two rules make the red state meaningful: a permission prompt or question stays red until answered, while a finished turn (`Stop`) is acknowledged — dropped to idle — the moment its window is the active window of an attached session, i.e. once you have looked at it. Stale files are pruned when their pane is gone or no longer runs claude, so a crashed session never leaves a ghost. Because the hooks live in `settings.json`, new Claude sessions register without any restart; to exercise the bar by hand, feed a fake event: `printf '{"session_id":"sim","hook_event_name":"Stop"}' | TMUX_PANE=%N tmux-claude-status hook`.

#### Making the cpu/ram numbers trustworthy

Both readings are deltas between consecutive ticks of a cumulative counter, stored in a small per-user state file. On Linux that counter is `/proc/stat`; on macOS it is `host_statistics64(HOST_CPU_LOAD_INFO)` — the ticks `top` and Activity Monitor read — reached through a three-line `python3` ctypes call, because macOS exposes them through no sysctl and no shell tool that doesn't pay a sampling delay (`top -l 2` costs 1.4s, `iostat -c 2` a full second). A first run with no previous sample falls back to the since-boot average, which is what a single reading of those counters actually means.

The CPU figure deliberately does **not** sum `ps -A -o %cpu=`. That column is a per-process decaying average over roughly the last minute, so it lags reality and badly overstates while a burst decays: measured at 267% against a true 53%, and 23% against a true 14.7%. Summing `ps -A -o time=` is closer but still undercounts by 3–5 points, because processes that exit between samples take their time with them and some kernel time is never attributed to a process at all.

The RAM figure counts **anonymous + wired + compressed** pages — what Activity Monitor calls "Memory Used", the pages that cannot be handed to another process without swapping. Counting `active` instead mixes in reclaimable file-backed pages while omitting inactive anonymous pages: that read 66.7% on a machine actually sitting at 74.4% with 0.08 GB free and 1.8 GB of swap in use, understating at precisely the moment the number matters. Past `TMUX_SYSINFO_MEM_ALERT` (85% by default) the value turns a red block, since beyond that the machine is about to start swapping.

`history-limit` is 100k lines per pane; the previous 1M made tmux itself a notable contributor to the memory pressure the bar is warning about.

### Session layouts (sesh + hook script)

Sessions are opened through [sesh](https://github.com/joshmedeski/sesh): the `s` alias in a plain shell (runs `~/.local/bin/sesh_start`, an fzf picker) or `prefix+K` inside tmux (same picker via `fzf-tmux`, defined in `tmux.conf`). `prefix+L` jumps back to the last session.

Layouts come from **two mechanisms**, so changes go in different places depending on which kind of session you're editing:

| Session kind | Layout source | Edit |
| --- | --- | --- |
| Pre-defined sessions (`home`, `dotfiles`, `tmux config`, `nvim config`, `work`, `personal`) | Declarative TOML | `~/.config/sesh/sesh.toml` + `~/.config/sesh/configs/windows.toml` |
| Ad-hoc repo sessions under `~/ws/work/` or `~/ws/personal/` | tmux `session-created` hook script | `~/.local/bin/tmux-session-layout` |

**Declarative (sesh TOML)** — `sesh.toml` defines named sessions (path, startup command) and references reusable windows from `configs/windows.toml` by name (`git`, `claude-work`, `claude-personal`, `dev`). sesh's TOML can't describe pane splits, so windows that need panes call a script instead: the `dev` window runs `~/.local/bin/sesh-dev-layout` (nvim on top, 25% shell pane below).

**Dynamic (hook script)** — `tmux.conf` sets a global `session-created` hook that runs `~/.local/bin/tmux-session-layout` for _every_ new session (sesh-created or not). For git **worktrees** under `~/ws/work/` or `~/ws/personal/` it builds a two-window layout and lands on window 1:

```text
1: claude   # Claude Code, CLAUDE_CONFIG_DIR picked from the path (work → ~/.claude-work, personal → ~/.claude-personal)
2: zsh      # plain shell — start nvim by hand when actually editing
```

nvim is never auto-started (each instance brings up TypeScript LSP node processes, which piles up across parallel worktree sessions), and lazygit is on demand via the `prefix+g` popup instead of a standing window. The script exits early for everything else: non-git paths, umbrella folders like `~/ws/work` itself, bare-clone roots (they stay plain shell hubs for `git wt`), detached review worktrees (read-only — no agent window), and sessions that already have a `claude` window (so it doesn't fight the sesh-defined sessions above). To give another path pattern its own layout, add a `case` branch in `tmux-session-layout`.

## 🌳 Git worktree workflow (`git bare-clone`, `git wt`)

`~/.local/bin/git-bare-clone` sets a repo up for working **exclusively from [git worktrees](https://git-scm.com/docs/git-worktree)** — one directory per branch, no stashing to switch context. Like plain `git clone`, it derives the project directory from the URL:

```bash
git bare-clone git@gitlab.example.com:group/my-repo.git   # creates my-repo/
git bare-clone <url> custom-name                          # explicit directory
git bare-clone <url> .                                    # set up in the current dir
```

`git bare-clone` / `git wt` need no registration: chezmoi applies `home/dot_local/bin/executable_git-*` as real executables at `~/.local/bin/git-*`, `~/.local/bin` is on `PATH`, and git's external-subcommand convention turns `git foo` into a `PATH` lookup for `git-foo` — the same mechanism as `git lfs`.

What `bare-clone` does: creates the project directory, clones **bare** into `.bare/` (override with `-l`/`--location`), sets the origin fetch refspec to `+refs/heads/*:refs/remotes/origin/*` (bare clones don't track remote branches by default, so `git fetch` would otherwise never create `origin/<branch>`), and writes a `.git` _file_ containing `gitdir: ./.bare` so the project directory is the repo root without a checkout of its own.

`~/.local/bin/git-wt` automates the day-to-day on top of it, with two classes of worktrees:

- **Fixed** — one per long-lived branch, dir name == branch name (`develop/`, `prod/`). Created locked so `git worktree remove` refuses; treat as read-mostly and branch off for changes.
- **Ephemeral** — one per task (feature, hotfix, MR review). Created on demand, removed when merged.

```bash
# One-time per repo: bare-clone into my-repo/ + locked fixed worktrees
# (default: develop prod) — then cd my-repo
git wt init git@gitlab.example.com:group/my-repo.git
git wt init <url> main            # explicit fixed branches; missing ones skipped

# Task worktrees — dir = last branch segment (feature/BE-1234 → BE-1234/),
# base defaults to origin/develop|main|master; copies .env* from a fixed worktree.
# If origin/<branch> already exists and no base-ref is given, tracks it instead.
git wt new feature/BE-1234
git wt new hotfix/BE-1300 origin/prod     # explicit base-ref always branches off

# MR review — detached HEAD, never blocks the author's branch
git wt review feature/BE-1290             # creates review-BE-1290/

# Finish — removes worktree + deletes the local branch (keeps it if unmerged)
git wt done BE-1234
git wt prune                              # remove all clean detached (review) worktrees, after confirmation
git wt ls
```

Shell shortcuts: `gwt` → `git wt`, `gwtl` → `git wt ls` (zsh aliases + fish abbrs).

```text
my-repo/
├── .git             # file: "gitdir: ./.bare"
├── .bare/           # the actual repository (objects, refs, config)
├── develop/         # FIXED  — latest integration code (locked)
├── prod/            # FIXED  — reproduce production issues (locked)
├── BE-1234/         # ephemeral — feature/BE-1234, removed after merge
└── review-BE-1290/  # ephemeral — detached MR review
```

Gotchas the script handles or you should know:

- `.env*` files are untracked, so new worktrees start without them — `git wt new` seeds them from the first fixed worktree that has any.
- `node_modules` is per-worktree (gitignored ⇒ invisible to git). Each worktree needs its own install; `pnpm` makes this cheap via its global hard-linked store.
- Git config, hooks, and signing live in `.bare/config` — shared by all worktrees automatically.
- A branch can be checked out in only **one** worktree at a time; reviews use detached HEAD to sidestep this (below).
- `git wt new`/`review` register the fresh worktree with zoxide (high seed score), so it shows up in the sesh picker immediately; `done`/`prune` deregister it again.
- `git wt` refuses to run in a normal clone (worktrees would show up as untracked dirs there — the bare layout has no parent checkout).
- `git clone --bare` mirrors every remote branch straight into local `refs/heads/*` with no upstream configured — `git wt init` and `git wt new <branch>` detect this and link to `origin/<branch>` via `git branch --set-upstream-to`.
- The project root (where `.bare/` lives) is plumbing, not a worktree — `cd` into `develop/`, `prod/`, or a task dir to work. Standing at the root shows `(bare)` in the Starship prompt (`custom.git_branch` module in `starship.toml`). Details in [`docs/git-worktree-bare-clone-workflow.md`](docs/git-worktree-bare-clone-workflow.md).

### Why review worktrees are detached

A normal checkout's `HEAD` points at a **branch**, so commits move that branch — the checkout _owns_ it. Detached HEAD points straight at a commit: same files on disk, fully buildable, but no branch claimed and nothing done there can move anyone's branch. `git wt review` insists on it because:

1. **Git enforces one checkout per branch across all worktrees.** Detaching is what makes a second checkout of the same commit legal — `BE-1234/ [feature/BE-1234]` and `review-BE-1234/ (detached)` can coexist on the exact same commit.
2. **A review is a read of a snapshot, not ownership of a branch.** Detaching at `origin/feature/BE-1290` gives exactly "what's in the MR right now"; a local branch could drift, get committed to by accident, or be pushed back over the author's work. Detached HEAD makes that path structurally impossible.
3. **Mid-review updates are trivial** — `git fetch && git checkout --detach origin/feature/BE-1290`.
4. **Cleanup is nothing** — removing a detached worktree removes everything, no leftover branch.

Detachment is also the **marker for "disposable review checkout"** elsewhere: `git wt prune` sweeps only detached worktrees (dirty ones are still kept), and `tmux-session-layout` keys its lighter no-agent layout on detached HEAD rather than the `review-` name. One-line version: **a branch checkout is a claim; a detached checkout is a photograph.**

## 🤖 Claude Code — multiple accounts

Run two Claude Code accounts (work + personal) on one machine without them colliding. Claude Code ties all of an account's state to a single config directory, selectable via `CLAUDE_CONFIG_DIR` ([technique reference](https://frontendhire.com/learn/ai/courses/using-multiple-claude-accounts/overview)). Two aliases (zsh and fish) point Claude at per-account dirs:

```bash
claude-work       # CLAUDE_CONFIG_DIR=~/.claude-work claude
claude-personal   # CLAUDE_CONFIG_DIR=~/.claude-personal claude
```

**What's isolated vs shared.** Each dir keeps its own login (on macOS in the Keychain, keyed per config dir), `history.jsonl`, `projects/`, and `sessions/`. Shared, read-mostly config is **symlinked** from `~/.claude` into each account dir so there is a single source of truth: `CLAUDE.md`, `settings.json`, `statusline.cjs`, `agents`, `commands`, `hooks`, `output-styles`, `rules`, `schemas`, `scripts`, `skills`, `plugins`, `workflows`. `bootstrap.sh` creates the dirs and symlinks (guarded on `~/.claude` existing); to do it by hand:

```bash
for dir in ~/.claude-work ~/.claude-personal; do
  mkdir -p "$dir"
  for item in CLAUDE.md settings.json statusline.cjs agents commands hooks \
              output-styles rules schemas scripts skills plugins workflows; do
    [ -e ~/.claude/"$item" ] && ln -sfn ~/.claude/"$item" "$dir/$item"
  done
done
```

**First-time login** — run each alias once and `/login` with the matching account. After that, use the alias that matches the repo you're in; `tmux-session-layout` picks the right one from the path automatically.

### Installing skills with AgentKit (`ak`)

[AgentKit](https://agentkit.best/docs) (`ak`, formerly `claudekit-cli`/`ck`) installs global skills/agents/hooks to `$CLAUDE_CONFIG_DIR` if set, otherwise to `~/.claude`. The aliases only export `CLAUDE_CONFIG_DIR` for the `claude` process, so from a plain terminal **`ak` installs to `~/.claude` and the symlinks propagate everything to both accounts**:

```bash
curl -fsSL https://agentkit.best/install.sh | sh   # one-time: installs ak to ~/.local/bin
ak kit init engineer                                 # writes to ~/.claude → both accounts see it
```

Cautions: don't run `ak` from inside a `claude-work`/`claude-personal` session (it would target the account dir); never run `ak uninstall` with `CLAUDE_CONFIG_DIR` pointed at an account dir (it could recurse through the symlinks into the real `~/.claude`); if `ak` adds a new top-level dir, re-run the seeding snippet above.

### Backing up `~/.claude` (separate private repo)

`~/.claude` is **not** tracked by this public repo — it holds the paid AgentKit kit — so it lives in its own private repo, [`phihdn/dotfiles-claude`](https://github.com/phihdn/dotfiles-claude), which commits the restorable config (ak layer snapshot, custom `CLAUDE.md`, `rules/`, `settings.json` — including the `tmux-claude-status` hooks — and `agent-memory/`) and gitignores every secret and machine-state path (`.env`, `history.jsonl`, `projects/`, `sessions/`, `cache/`, `telemetry/`, `plugins/`, …). It is a standalone clone, not a submodule.

`bootstrap.sh` restores it (needs GitHub SSH/`gh` auth first) with the equivalent of:

```bash
git clone git@github.com:phihdn/dotfiles-claude.git ~/.claude
ak kit refresh core --yes && ak kit refresh engineer --yes && ak kit refresh marketing --yes
```

Back it up by committing from `~/.claude` (`git -C ~/.claude add -A && git -C ~/.claude commit -m "chore: update claude config" && git -C ~/.claude push`). Anything you author yourself gets a `phi-` prefix (`skills/phi-*`, `hooks/phi-*.cjs`) so it stands apart from ak content and survives `ak kit refresh`.

## 🔄 Day-to-day chezmoi

```bash
chezmoi diff                        # what would change in $HOME
chezmoi apply                       # write it
chezmoi apply --dry-run -v
chezmoi edit ~/.config/zsh/.zshrc   # edit the source under home/, then apply
chezmoi add ~/.config/newapp/config # start managing a file (adds under home/ with the right name)
chezmoi add --template ~/.some.secret
chezmoi managed                     # everything chezmoi manages
chezmoi doctor
```

chezmoi writes **real files** to `$HOME`, not symlinks — always edit the source (via `chezmoi edit` or directly under `home/`) and apply, never the target. Per-machine state that must never be applied goes in `home/.chezmoiignore` (gitignore syntax, templated so sections can be OS-conditional); targets that should be _deleted_ from `$HOME` go in `home/.chezmoiremove`.

### Updating

```bash
cd ~/dotfiles && git pull   # auto-applies via git hook
./bootstrap.sh              # also refreshes tools and packages
```

A `git pull` runs `chezmoi apply` through tracked hooks in `.githooks/`: `post-merge` for merge-style pulls and `post-rewrite` for rebase-style pulls (this repo sets `pull.rebase = true`, so pulls rebase and would otherwise skip `post-merge`; it runs only for rebases, not `git commit --amend`). Both no-op if `chezmoi` is absent. `bootstrap.sh` enables them with `git config core.hooksPath .githooks`; since that lives in the local `.git/config`, each fresh clone needs bootstrap (or that command) once.

### Troubleshooting

- **Secret/template errors** (WakaTime, work gitconfig): `eval "$(op signin)"` then `chezmoi apply`.
- **Adopt existing `$HOME` files** as the new source of truth: `chezmoi add ~/.config/nvim`.
- **Status bar shows stale or empty segments**: check the daemon is alive with `tmux show -gv @status_daemon_pid`; restart it as described under [Fork-free rendering](#fork-free-rendering-tmux-status-daemon).
- **Wrong `node`** inside a tool: `command -v node` — see [node / nvm on PATH](#node--nvm-on-path).
