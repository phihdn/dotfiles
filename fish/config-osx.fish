if type -q exa
  alias ll "exa -l -g --icons"
  alias lla "ll -a"
end

# Go
set -g GOPATH $HOME/go
set -g GOROOT /opt/homebrew/bin/go
set -gx PATH $GOPATH/bin $PATH
set -gx PATH $GOROOT/bin $PATH