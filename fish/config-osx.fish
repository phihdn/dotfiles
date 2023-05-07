#echo "osx loading..."
fish_add_path /opt/homebrew/bin # https://brew.sh/
fish_add_path /opt/homebrew/sbin
# Go
set -Ux GOPATH (go env GOPATH) # https://go.dev
set -Ux GOROOT (brew --prefix)/opt/go/libexec
fish_add_path $GOPATH/bin
fish_add_path $GOROOT/bin

#echo "osx loaded"
