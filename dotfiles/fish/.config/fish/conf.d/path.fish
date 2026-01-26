# PATH configuration - loaded early

# Homebrew (macOS)
if test -d /opt/homebrew
    fish_add_path -gP /opt/homebrew/bin /opt/homebrew/sbin
    set -gx HOMEBREW_PREFIX /opt/homebrew
end

# GNU coreutils and findutils (prefer over BSD)
fish_add_path -gP /opt/homebrew/opt/coreutils/libexec/gnubin
fish_add_path -gP /opt/homebrew/opt/findutils/libexec/gnubin

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
