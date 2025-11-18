#!/usr/bin/env bash
# =============================================================================
# Nix Removal Script for macOS
# =============================================================================

set -e

echo "🗑️  Removing Nix from macOS..."

# Stop Nix services
echo "Stopping Nix services..."
sudo launchctl unload /Library/LaunchDaemons/org.nixos.nix-daemon.plist 2>/dev/null || true
sudo rm -f /Library/LaunchDaemons/org.nixos.nix-daemon.plist
launchctl unload ~/Library/LaunchAgents/org.nixos.nix-daemon.plist 2>/dev/null || true
rm -f ~/Library/LaunchAgents/org.nixos.nix-daemon.plist

# Remove Nix directories
echo "Removing Nix directories..."
# Remove the main Nix store, ignoring system files
sudo find /nix -mindepth 1 -not -name ".Spotlight-V100" -not -name ".Trashes" -not -name ".fseventsd" -exec rm -rf {} + 2>/dev/null || true
# Try to remove the directory itself (may fail if system files remain)
sudo rmdir /nix 2>/dev/null || echo "Note: /nix directory may contain system files - this is normal"

sudo rm -rf /etc/nix 2>/dev/null || true
rm -rf ~/.nix-profile 2>/dev/null || true
rm -rf ~/.nix-defexpr 2>/dev/null || true
rm -rf ~/.nix-channels 2>/dev/null || true
rm -rf ~/.config/nix 2>/dev/null || true
rm -rf ~/.cache/nix 2>/dev/null || true

# Clean shell configurations
echo "Cleaning shell configurations..."
for file in ~/.zshrc ~/.bash_profile ~/.bashrc ~/.profile; do
    if [[ -f "$file" ]]; then
        sed -i.bak '/nix/d' "$file" 2>/dev/null || true
    fi
done

# Remove Nix users and groups
echo "Removing Nix users and groups..."
for i in $(seq 1 32); do
    sudo dscl . -delete /Users/_nixbld$i 2>/dev/null || true
done
sudo dscl . -delete /Groups/nixbld 2>/dev/null || true

# Remove Nix-managed Homebrew
echo "Removing Nix-managed Homebrew..."
sudo rm -rf /usr/local/Homebrew 2>/dev/null || true
sudo rm -rf /opt/homebrew 2>/dev/null || true

# Final cleanup check
echo "Performing final cleanup..."
if [[ -d "/nix" ]]; then
    # If /nix still exists, it likely contains only system files
    nix_contents=$(ls -la /nix 2>/dev/null | wc -l)
    if [[ $nix_contents -le 3 ]]; then
        echo "✅ /nix directory is effectively empty (only system files remain)"
    else
        echo "⚠️  /nix directory still contains some files - this may be normal"
        echo "   You can safely ignore this if only .Spotlight-V100, .Trashes, or .fseventsd remain"
    fi
fi

echo ""
echo "✅ Nix removal complete!"
echo ""
echo "Next steps:"
echo "1. Restart your terminal: exec \$SHELL -l"
echo "2. Reinstall Homebrew: /bin/bash -c \"\$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)\""
echo "3. Run your bootstrap script: ./bootstrap.sh"
echo ""
echo "Note: System files like .Spotlight-V100 and .Trashes are protected by macOS and cannot be removed."
echo "      This is completely normal and doesn't affect Nix removal."
