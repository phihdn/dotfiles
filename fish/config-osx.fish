#echo "osx loading..."
if test -d /home/linuxbrew/.linuxbrew # Linux
	set -gx HOMEBREW_PREFIX "/home/linuxbrew/.linuxbrew"
	set -gx HOMEBREW_CELLAR "$HOMEBREW_PREFIX/Cellar"
	set -gx HOMEBREW_REPOSITORY "$HOMEBREW_PREFIX/Homebrew"
else if test -d /opt/homebrew # MacOS
	set -gx HOMEBREW_PREFIX "/opt/homebrew"
	set -gx HOMEBREW_CELLAR "$HOMEBREW_PREFIX/Cellar"
	set -gx HOMEBREW_REPOSITORY "$HOMEBREW_PREFIX/homebrew"
end
fish_add_path -gP "$HOMEBREW_PREFIX/bin" "$HOMEBREW_PREFIX/sbin";
! set -q MANPATH; and set MANPATH ''; set -gx MANPATH "$HOMEBREW_PREFIX/share/man" $MANPATH;
! set -q INFOPATH; and set INFOPATH ''; set -gx INFOPATH "$HOMEBREW_PREFIX/share/info" $INFOPATH;

# Go
set -Ux GOPATH (go env GOPATH) # https://go.dev
set -Ux GOROOT (brew --prefix)/opt/go/libexec
fish_add_path $GOPATH/bin
fish_add_path $GOROOT/bin

# 1Password
set -Ux SSH_AUTH_SOCK ~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

#echo "osx loaded"
