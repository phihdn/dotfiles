# Neovim Keymaps

Keymap reference for `home/dot_config/nvim`. Leader and localleader are both `<Space>`.

The scheme is your personal one, restored from branch `20260915-nvim-pre-smnatale` and layered on top of the upstream smnatale config. It lives in `lua/config/keymaps-personal.lua`, which loads last so it can override upstream mappings. Where the old config used a plugin this one no longer ships, the binding points at the current equivalent: fzf-lua → telescope, trouble → telescope + quicker, diffview → zdiff.

Two ways to discover keymaps live: press `<Space>` and wait 300ms for the which-key popup, or `<leader>fk` for the searchable telescope keymap picker.

## Leader groups

| Prefix | Group |
| --- | --- |
| `<leader>b` | buffer |
| `<leader>c` | code / quickfix |
| `<leader>e` | explorer |
| `<leader>f` | find |
| `<leader>g` | git / goto |
| `<leader>r` | restart / rename / rotate |
| `<leader>s` | split |
| `<leader>t` | test |
| `<leader>u` | ui / toggles |
| `<leader>x` | diagnostics |
| `<leader>z` | zdiff |
| `gs` | surround (mini.surround) |

## Core editing

| Key | Mode | Action |
| --- | --- | --- |
| `jk` | i | Exit insert mode |
| `j` / `k` | n | Move by screen line when wrapped; real lines with a count (`5j`) |
| `J` | n | Join lines, cursor stays put |
| `J` / `K` | v | Move selection down / up |
| `<` / `>` | v | Indent without losing the selection |
| `p` | x | Paste over selection without clobbering the unnamed register |
| `x` | n | Delete character without touching the register |
| `X` | n | Split line at cursor |
| `U` | n | Redo |
| `<C-d>` / `<C-u>` | n | Half page down / up, re-centered |
| `n` / `N` / `*` / `#` / `g*` / `g#` | n | Search motions, re-centered with folds opened |
| `<Esc>` | n | Clear search highlight + multicursors |
| `gl` | n | Diagnostics float |
| `<leader>w` | n | Save file |
| `<leader>q` | n, t | Quit buffer |
| `<leader>y` | n, x | Copy to clipboard |
| `<leader>Y` | n | Copy line to clipboard |
| `<leader>ym` | n | Yank `:messages` to clipboard |
| `<leader>fp` | n | Copy file path to clipboard |
| `<leader>cp` | v | Copy `path:start:end` + optional note, for pasting into AI chats |
| `<leader>m` | n | Toggle split/join code block (treesj) |
| `<leader>lg` | n | Log the variable under cursor (chainsaw) |
| `<leader>M` | n | Toggle in-buffer markdown rendering |

## Explorer

| Key | Action |
| --- | --- |
| `-` | Oil, parent directory |
| `\` | Oil, floating window |
| `<leader>-` | Toggle Oil float |
| `<leader>ee` | Toggle mini.files explorer |
| `<leader>ef` | mini.files at the current file's directory |

Inside mini.files: `<CR>` go in (closes on a file), `L` go in plus, `-` go out, `H` go out plus, `<Esc>` close.

## Find — `<leader>f`

| Key | Action |
| --- | --- |
| `<leader>ff` | Find files in project (frecency-ranked, hidden included) |
| `<leader>fg` | Grep in project |
| `<leader>fn` | Find in Neovim config |
| `<leader>fh` | Help tags |
| `<leader>fk` | Keymaps |
| `<leader>fb` | Buffers |
| `<leader>fz` | Telescope builtin pickers |
| `<leader>fw` / `<leader>fW` | Grep word / WORD under cursor |
| `<leader>fd` / `<leader>fD` | Buffer / workspace diagnostics |
| `<leader>fr` | Resume last picker |
| `<leader>fo` | Old files |
| `<leader>f"` | Registers |
| `<leader><leader>` | Buffers |
| `<leader>:` | Command history |
| `<leader>/` | Fuzzy find in current buffer |

`<C-q>` inside any picker sends the selection to the quickfix list and opens it.

## Splits and buffers

| Key | Action |
| --- | --- |
| `<leader>sv` | Split vertically |
| `<leader>sh` | Split horizontally |
| `<leader>se` | Equalize splits |
| `<leader>sx` | Close split |
| `<C-h>` / `<C-j>` / `<C-k>` / `<C-l>` | Move to left / below / above / right split |
| `<leader>rr` | Rotate splits |
| `<leader>re` | Restart Neovim |
| `<leader>v` | Vertical split (upstream alias for `<leader>sv`) |
| `<S-l>` / `<S-h>` | Next / previous buffer |
| `<leader>bd` | Delete buffer |
| `<C-c>` | Wipeout buffer |

## LSP

Buffer-local; they exist once a server attaches.

| Key | Mode | Action |
| --- | --- | --- |
| `K` | n | Hover documentation (builtin) |
| `gd` / `gD` | n | Definition / declaration |
| `grr` | n | References |
| `gri` | n | Implementations |
| `grt` | n | Type definition |
| `gO` / `gW` | n | Document / workspace symbols |
| `grn` | n | Rename (builtin) |
| `gra` | n | Code action (builtin) |
| `<leader>ca` | n, v | Code action (tiny-code-action picker) |
| `<leader>cf` | n, v | Format buffer (conform) |
| `<leader>rn` | n | Rename symbol |
| `<leader>d` | n | Diagnostics float |
| `<leader>gd` / `<leader>gi` / `<leader>gr` / `<leader>D` | n | Definition / implementation / references / type definition |

## Diagnostics and quickfix — `<leader>x`, `<leader>c`

| Key | Action |
| --- | --- |
| `<leader>xw` | Workspace diagnostics |
| `<leader>xd` | Document diagnostics |
| `<leader>xq` | Toggle quickfix list |
| `<leader>xl` | Toggle location list |
| `<leader>co` | Toggle quickfix list (upstream alias) |
| `<leader>cn` / `<leader>cp` | Next / previous quickfix item |

## Git

| Key | Action |
| --- | --- |
| `<leader>gv` | Diff working tree (zdiff) |
| `<leader>gV` | Diff against `main` (zdiff) |
| `<leader>zd` / `<leader>zD` | Same two, upstream aliases |
| `<leader>gc` | Search git commits |
| `<leader>gs` | Search git status |
| `<leader>gm` | Gitsigns diff current file against `main` |
| `<leader>uB` | Toggle inline git blame |

## Testing — `<leader>t`

| Key | Action |
| --- | --- |
| `<leader>tr` | Run nearest test |
| `<leader>tf` | Run file tests |
| `<leader>ts` | Test summary |
| `<leader>to` | Test output |
| `<leader>tp` | Test output panel |

## Go

| Key | Action |
| --- | --- |
| `<leader>gt` | Toggle between a Go file and its `_test.go` |
| `<leader>god` | Go documentation |

## Completion (blink.cmp)

| Key | Action |
| --- | --- |
| `<Tab>` | Accept completion, else fall through to tabout |
| `<CR>` | Accept completion, else newline |
| `<S-Tab>` | Show completion menu |
| `<C-j>` / `<C-k>` | Select next / previous item |

## mini.nvim text objects

- `mini.surround` on the `gs` prefix — `gsa"` add, `gsd"` delete, `gsr"'` replace, `gsf`/`gsF` find, `gsh` highlight.
- `mini.ai` — `af`/`if` function, `ac`/`ic` class, `aa`/`ia` argument, plus any bracket or quote.
- `mini.pairs` — auto-closing brackets and quotes.
- `mini.jump` — `f`, `F`, `t`, `T` repeat with `;` and work across lines.

mini.surround sits on `gs` precisely so flash can own plain `s`.

## Motion and todo comments

| Key | Mode | Action |
| --- | --- | --- |
| `s` | n, x, o | Flash jump |
| `S` | n, x, o | Flash treesitter |
| `]t` / `[t` | n | Next / previous todo comment |
| `<leader>xt` | n | Search todo comments |

## Not restored

One old binding has no home in the current plugin set: `[s` / `]s`, the mini.indentscope scope motions. The module ships with mini.nvim but is not set up.
