# Abbreviations - expand on space/enter

# Git
abbr -a ga "git add ."
abbr -a gb "git branch -v"
abbr -a gc "git commit"
abbr -a gca "git commit -av"
abbr -a gcl "git clone"
abbr -a gco "git checkout -b"
abbr -a gd "nvim +DiffviewOpen"
abbr -a gf "git fetch --prune --all"
abbr -a gl "git pull"
abbr -a gma "git merge --abort"
abbr -a gmc "git merge --continue"
abbr -a gp "git push"
abbr -a gpf "git push origin --force-with-lease"
abbr -a gpom "git pull origin main"
abbr -a gpo "git push origin --set-upstream HEAD"
abbr -a gpr "gh pr create"
abbr -a gr "git remote"
abbr -a gra "git remote add"
abbr -a grv "git remote -v"
abbr -a gs "git status"

# File listing (lsd)
abbr -a l "lsd --group-dirs first -A"
abbr -a ll "lsd --group-dirs first -Al"
abbr -a lt "lsd --group-dirs last -A --tree"

# Tools
abbr -a lg lazygit
abbr -a ld lazydocker

# Session management
abbr -a s sesh_start
abbr -a s. "sesh connect ."

# Kubernetes
abbr -a k kubectl
abbr -a kc "kubectl config current-context"
abbr -a kctx "kubectl config use-context"
abbr -a kns "kubectl config set-context --current --namespace"
