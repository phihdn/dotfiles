function sesh_start --description "Start sesh session picker with fzf"
    set -l session (sesh list | fzf --height 40% --reverse --border)
    if test -n "$session"
        sesh connect $session
    end
end
