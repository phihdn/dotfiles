# Nvim Self-Config Revival

**Date**: 2026-07-30 00:02
**Severity**: Low
**Component**: nvim config (`home/dot_config/nvim-self/`)
**Status**: Ongoing (trial period)

## What Happened

Ran a self-maintained, kickstart-derived nvim config for about two years, then jumped to LazyVim on 2026-07-10 because keeping up with the plugin ecosystem solo had become a drag. Nineteen days later, on 2026-07-29, decided to reverse course: LazyVim bundles far more than needed, and the original blocker — tracking churn across dozens of plugins alone — is no longer a solo problem. Claude now does on-breakage triage plus a quarterly health check (recorded in the plan's Maintenance protocol), so the config can go back to being hand-picked instead of pre-bundled.

Executed as a three-phase plan (`plans/260729-2304-nvim-self-config-revival/plan.md`), built in parallel next to the live LazyVim setup via `NVIM_APPNAME=nvim-self` (alias `nvs`) so nothing broke the daily driver mid-migration.

## The Brutal Truth

The nice surprise: phase 01 (07d9a27) restoring the frozen `20260710-nvim-pre-lazyvim` branch into `home/dot_config/nvim-self/` booted clean on the first try — zero Lua errors, checkhealth green. The treesitter `main`-branch migration everyone worries about had quietly already happened before the config was abandoned, so an entire planned phase-02 workstream evaporated before it started. Small win, but it meant less time re-litigating decisions already made two years ago.

The less nice part: two years of drift meant real bit-rot to clean up in phase 02 (8b35965) — a 289-line hand-rolled lspconfig block that nvim 0.11's native `vim.lsp.config`/`vim.lsp.enable` made obsolete, a `mason-lspconfig` dependency that turned out to be dead weight once PATH prepending was verified straight from mason's source, and a keymap bug where a duplicate `j`/`k` mapping was silently eating count motions (`5j` just did `j`). That kind of thing sits there for years because nobody notices — it just feels like "vim is being vim."

## Technical Details

- Phase 01 (`07d9a27`): 33 files, 2304 insertions, net-new `home/dot_config/nvim-self/`; `nvs` alias added to both zsh and fish; isolated plugin/state dirs so `nvim-self` never touches LazyVim's.
- Phase 02 (`8b35965`): net −337 lines (256 insertions / 593 deletions). `lsp.lua` 289→~130 lines via native `vim.lsp.config()`/`vim.lsp.enable()`; `mason-lspconfig` dropped entirely (mason-tool-installer + explicit enable list); `basedpyright` added; `telescope.lua` (254 lines) and `kanagawa.lua` (65 lines) deleted outright, `fzf-lua` as sole picker with `register_ui_select()` replacing telescope-ui-select; `catppuccin-gruvbox.lua` new theme file with gruvbox-material `color_overrides`; `lazy-lock.json` committed for the first time (37 lines).
- Phase 03 (`99bfc0f`): 112 insertions / 107 deletions across 7 files. `render-markdown` `anti_conceal` disabled (perf regression from commit `341e8de` where per-keystroke cursor-line re-render made `j`/`k` laggy in large markdown files); new `nvim-lint.lua` (31 lines) wiring `markdownlint-cli2` with the global `~/.markdownlint-cli2.jsonc` passed explicitly; `diffview.lua` new (24 lines, `<leader>gv`/`<leader>gV`); `gitsigns` blame tuned to 500ms + relative time with `<leader>uB` toggle; `lualine.lua`/`markdown.lua` palettes swapped from hardcoded kanagawa-dragon hex to gruvbox-material.
- Code review (subagent, phase 02): 0 critical/high, 2 medium — eager `fzf-lua` require inside `LspAttach` (fixed: moved to per-key lazy closures) and a `<leader>fb` semantics change (fixed: restored buffers-picker binding, moved the builtin-picker list to `<leader>fz`).

## What We Tried

- Debugging note from phase 03: the first markdown buffer opened in a session missed linting entirely. Root cause — plugin config for `nvim-lint` runs during `BufReadPost`, which fires *before* `FileType` is set on that same buffer, so the lint-on-`FileType` autocmd never caught the first buffer. Fixed by also triggering the lint on `FileType` itself (in addition to `BufWritePost`/`InsertLeave`), not just relying on the read event.
- Considered adding `guess-indent` back from the LazyVim-era feature list; skipped — `vim-sleuth` already covers indent detection, no point running two plugins for one job.
- Considered keeping `mason-lspconfig` "just in case" PATH wiring depended on it; verified against mason's own source that PATH prepending doesn't need it, dropped it instead of carrying dead configuration forward on a hunch.

## Root Cause Analysis

The original 2026-07-10 abandonment wasn't really about the config being bad — it was about a solo maintenance burden (tracking plugin renames, deprecations, breaking changes across ~25 plugins) that made LazyVim's "someone else curates this" model look attractive. But LazyVim's answer to that problem is over-inclusion: bundling far more plugins/features than actually get used, trading maintenance burden for bloat. Once AI-assisted triage removed the actual bottleneck (solo ecosystem tracking), the trade favoring LazyVim's bundling no longer made sense.

## Lessons Learned

- A tool abandoned for "I can't keep up with this ecosystem" reasons is worth re-evaluating once the actual bottleneck (maintenance labor) changes, rather than treating the original decision as permanent.
- Building the replacement as a genuinely parallel profile (`NVIM_APPNAME=nvim-self`, isolated plugin/state dirs) rather than in-place rewrite meant the live daily-driver config was never at risk during a 3-commit, ~3-hour migration — worth doing for any config-swap of this size.
- `mason-lspconfig` and other "glue" plugins accumulate in configs without anyone re-checking if they're still load-bearing; verifying against source before ripping one out (rather than trusting muscle memory) caught that it wasn't needed at all.
- Autocmd event ordering (`BufReadPost` vs `FileType`) is a recurring trap for "run this plugin setup on file open" logic — the first buffer in a session is not like the rest.
- Committing `lazy-lock.json` from day one (it wasn't committed in phase 01) avoids silent version drift; the trade-off is a manual copy-back step (`cp ~/.config/nvim-self/lazy-lock.json home/dot_config/nvim-self/`) after every `:Lazy update` in the trial, since chezmoi apply will otherwise report the target as locally modified.

## Next Steps

- Owner: repo user. Drive `nvs` as the daily editor for 1-2 weeks (trial period, per plan phase 03 steps 4-6 not yet executed).
- During trial: decide the Oil vs nvim-tree explorer redundancy (both currently kept, per plan's unresolved questions) and confirm `blink.cmp` pin is still current against release notes.
- After trial: final swap — `chezmoi apply` promotes `nvim-self` to manage `~/.config/nvim` directly, LazyVim state gets snapshotted to a dated branch per repo tradition (`2026MMDD-nvim-pre-self`).
- Ongoing: quarterly health check with Claude (scan for archived/retired plugins, check for new nvim core features that let more hand-rolled config get deleted) — first one due roughly Q4 2026.
