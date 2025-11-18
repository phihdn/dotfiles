# Migration to GNU Stow

This document explains the migration from the old custom linking system to GNU Stow.

## What Changed

### Old System
- Used `links.prop` files to define source→destination mappings
- Custom `bootstrap.sh` script processed these mappings
- Configuration files were in `*/conf/` subdirectories
- Manual symlink management

### New System  
- Uses GNU Stow for symlink management
- Each package directory mirrors the target filesystem structure
- Simplified installation with `./install.sh`
- Standard tool with better conflict resolution

## Directory Structure Changes

### Before
```
nvim/
├── conf/           # Config files here
│   ├── init.lua
│   └── lua/...
└── links.prop      # Mapping file

fish/
├── config.fish
├── conf.d/...
└── links.prop
```

### After
```
nvim/
└── .config/        # Mirrors ~/.config/
    └── nvim/       # Target directory
        ├── init.lua
        └── lua/...

fish/
└── .config/        # Mirrors ~/.config/
    └── fish/       # Target directory  
        ├── config.fish
        └── conf.d/...
```

## Migration Steps Performed

1. **Analyzed existing structure** - Examined all `links.prop` files to understand current mappings
2. **Created stow packages** - Restructured each tool's config to match target filesystem layout
3. **Backed up original** - Moved old structure to `.backup-original/`
4. **Created new installer** - Replaced `bootstrap.sh` with `install.sh` using GNU Stow
5. **Updated documentation** - New README with GNU Stow instructions

## Package Mapping

| Old Directory | New Stow Package | Target Location |
|---------------|------------------|-----------------|
| `nvim/conf/` | `nvim/.config/nvim/` | `~/.config/nvim/` |
| `fish/` | `fish/.config/fish/` | `~/.config/fish/` |
| `git/conf/gitconfig` | `git/.gitconfig` | `~/.gitconfig` |
| `tmux/conf/` | `tmux/.config/tmux/` | `~/.config/tmux/` |
| `zsh/conf/zshrc` | `zsh/.config/zsh/.zshrc` | `~/.config/zsh/.zshrc` |
| `zsh/conf/zshenv` | `zsh/.zshenv` | `~/.zshenv` |
| `scripts/` | `scripts/.local/bin/` | `~/.local/bin/` |

## Installing After Migration

1. **Uninstall old symlinks** (if any exist):
   ```bash
   # Remove existing symlinks manually or use old bootstrap.sh to remove
   ```

2. **Install with GNU Stow**:
   ```bash
   ./install.sh
   ```

3. **Verify installation**:
   ```bash
   # Check that configs are properly linked
   ls -la ~/.config/nvim  # Should show symlink to dotfiles
   ```

## Rollback (if needed)

If you need to rollback to the old system:

1. **Uninstall stow packages**:
   ```bash
   ./install.sh uninstall
   ```

2. **Restore old structure**:
   ```bash
   rm -rf nvim fish git tmux zsh  # etc.
   mv .backup-original/* .
   ```

3. **Use old bootstrap**:
   ```bash
   ./_install/bootstrap.sh
   ```

## Benefits of GNU Stow

- **Standard tool** - Well-documented, widely used
- **Conflict detection** - Better handling of existing files
- **Selective installation** - Install only specific packages
- **Dry run support** - Preview changes before applying
- **Adoption** - Can adopt existing files into packages
- **Simpler maintenance** - No custom scripts to maintain

## Troubleshooting

### Existing files conflict
```bash
# Option 1: Remove conflicting files
rm ~/.config/nvim/init.lua

# Option 2: Adopt existing files
stow --adopt nvim
```

### Broken symlinks after moving dotfiles
```bash
./install.sh restow
```

### Check what stow would do
```bash
stow -n -v nvim  # Dry run with verbose output
```
