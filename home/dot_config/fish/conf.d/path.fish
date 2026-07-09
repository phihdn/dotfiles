# PATH configuration - loaded early

# Homebrew (macOS arm64: /opt/homebrew, macOS Intel: /usr/local, Linuxbrew)
for brew_prefix in /opt/homebrew /usr/local /home/linuxbrew/.linuxbrew
    if test -x $brew_prefix/bin/brew
        fish_add_path -gP $brew_prefix/bin $brew_prefix/sbin
        set -gx HOMEBREW_PREFIX $brew_prefix
        break
    end
end

# GNU coreutils and findutils (prefer over BSD; Homebrew-only, macOS)
if set -q HOMEBREW_PREFIX
    fish_add_path -gP $HOMEBREW_PREFIX/opt/coreutils/libexec/gnubin
    fish_add_path -gP $HOMEBREW_PREFIX/opt/findutils/libexec/gnubin
end

# User binaries
fish_add_path $HOME/.local/bin

# Go
if type -q go
    set -gx GOPATH (go env GOPATH 2>/dev/null)
    if test -n "$GOPATH"
        fish_add_path $GOPATH/bin
    end
end

# Bun
fish_add_path $HOME/.bun/bin

# Rancher Desktop
if test -d $HOME/.rd/bin
    fish_add_path $HOME/.rd/bin
end

# LM Studio CLI
if test -d $HOME/.cache/lm-studio/bin
    fish_add_path $HOME/.cache/lm-studio/bin
end

# Kubernetes config
if test -f $HOME/.kube/config-k3s-homelab
    set -gx KUBECONFIG $HOME/.kube/config:$HOME/.kube/config-k3s-homelab
end
