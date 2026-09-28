# Neovim Keymaps

Cheat sheet for `home/dot_config/nvim`. Leader is `<Space>`. Press `<Space>` and wait for which-key to list a prefix, or search every mapping with `<leader>fk`. Core maps live in `lua/phihdn/core/keymaps.lua`; plugin maps sit next to their plugin in `lua/phihdn/plugins/`.

## Leader groups

| Prefix | Group | Examples |
| --- | --- | --- |
| `<leader>b` | buffer | `bd` delete buffer |
| `<leader>c` | code | `cf` format buffer or selection |
| `<leader>e` | explorer (mini.files) | `ee` toggle, `ef` reveal current file |
| `<leader>f` | find (fzf-lua) | `ff` files, `fg` grep, `fo` recent, `fr` resume, `fk` keymaps |
| `<leader>g` | git | `ga` stage hunk, `gr` reset hunk, `gp` preview, `gb` blame, `gv` diffview |
| `<leader>s` | split | `sv` vertical, `sh` horizontal, `se` equalize, `sx` close |
| `<leader>u` | ui toggles | `uw` wrap, `us` spell, `ud` diagnostics, `uh` inlay hints, `um` markdown rendering, `uB` inline blame |
| `<leader>x` | diagnostics lists (trouble) | `xw` workspace, `xd` buffer, `xq` quickfix, `xt` todos |
| `<leader>y` | yank to clipboard | `y{motion}`, `Y` line, `yp` file path, `ym` messages |

Also on the leader: `<leader><leader>` buffers, `<leader>/` grep current buffer, `<leader>:` command history, `<leader>p` / `<leader>P` paste from the clipboard, `<leader>?` buffer-local keymaps.

## Clipboard

Plain `y` / `p` use nvim's registers; the system clipboard is opt-in through the leader, so deletes never clobber it. `<leader>y` / `<leader>p` mirror `y` / `p` against the clipboard. In visual mode `p` pastes over the selection without overwriting the register, and `x` deletes a character without touching registers.

## LSP

Set on attach. `gd` definition, `gD` declaration, `grr` references, `gri` implementations, `grt` type definition, `gO` document symbols, `gW` workspace symbols (all through fzf-lua). nvim's own defaults cover the rest: `K` hover, `grn` rename, `gra` code action, `<C-s>` signature help in insert mode.

## Brackets

| Keys | Moves to |
| --- | --- |
| `[d` / `]d` | diagnostic (nvim default) |
| `[h` / `]h` | git hunk |
| `[t` / `]t` | TODO comment |
| `[i` / `]i` | edge of the current indent scope |
| `[q` / `]q` | quickfix entry (nvim default) |
| `[s` / `]s` | misspelled word (nvim default) |

## Motion and editing

| Keys | Action |
| --- | --- |
| `s` / `S` | flash jump / flash treesitter select |
| `-` / `\` | oil: parent directory in place / in a float |
| `H` / `L` | previous / next buffer |
| `C-h/j/k/l` | move between splits and tmux panes |
| `gl` | line diagnostics float |
| `jk` | leave insert mode |
| `J` / `K` (visual) | move selection down / up |
| `X` | split the line at the cursor |
| `gsa` / `gsd` / `gsr` | surround add / delete / replace |

## Text objects

`af`/`if` function, `ac`/`ic` class, `aa`/`ia` argument, `ao`/`io` block, loop or conditional, `ai`/`ii` indent scope, `ih` git hunk. mini.ai adds next/last variants, for example `vinq` selects inside the next quote.
