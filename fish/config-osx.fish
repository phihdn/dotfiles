#echo "osx loading..."
fish_add_path /opt/homebrew/bin # https://brew.sh/
fish_add_path /opt/homebrew/sbin

# Go
set -Ux GOPATH (go env GOPATH) # https://go.dev
set -Ux GOROOT (brew --prefix)/opt/go/libexec
fish_add_path $GOPATH/bin
fish_add_path $GOROOT/bin

# 1Password
set -Ux SSH_AUTH_SOCK ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

#echo "osx loaded"
