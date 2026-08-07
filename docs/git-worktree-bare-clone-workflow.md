# Git Worktree: Plain Usage vs. the Bare-Clone Organizational Pattern

Personal notes on `git worktree`, and on the `git-bare-clone` / `git-wt` scripts in this repo that build a specific organizational pattern on top of it. Written to relearn a trick originally picked up from a YouTube video that's since gone unfindable.

## The problem `git worktree` solves

A normal `git clone` gives you **one working directory tied to one checked-out branch**. Switching branches means `git checkout`/`git switch`, which:

- Requires a clean tree, or forces a `git stash` round-trip.
- Wipes out anything branch-specific that lives outside git's index — a running dev server, an in-progress build, `node_modules` left in a state that matches the old branch.
- Makes it impossible to have two branches "open" side by side (e.g. reviewing a PR while mid-feature on another branch) without a second full clone.

`git worktree` (native git feature since 2.5) fixes this: **one repository, many working directories**, each with its own checked-out branch, all sharing the same object store (`.git/objects`) so there's no duplicated history.

```bash
git worktree add ../my-repo-hotfix hotfix/BE-1300   # new worktree + new branch
git worktree add ../my-repo-review origin/feature/x --detach  # read-only review
git worktree list                                    # see them all
git worktree remove ../my-repo-hotfix                # done
```

## Plain worktree usage: the asymmetry

The `git worktree add ...` docs example above assumes you already have a normal clone — that original clone keeps being "special": it's the one with the real `.git/` directory, every other worktree is a `.git` *file* pointing back at it (`gitdir: /path/to/main-clone/.git/worktrees/<name>`). Two consequences:

1. The main clone's branch can't easily be treated the same as the others — it's "the repo", not "a worktree".
2. If you ever want to delete/rename the original clone, every other worktree breaks (they all point back at its `.git/`).

This is fine for occasional worktree use, but if the *whole point* is "always work from worktrees, never touch a checked-out branch in the primary clone", that asymmetry becomes friction.

## The bare-clone pattern: make every branch equally a worktree

The trick: clone **bare** (`git clone --bare`, no working tree at all) into a hidden `.bare/` subdirectory, then make the *project root* itself resolve to that bare repo via a `.git` file.

### Why not just `git clone --bare <url> my-repo` directly?

A bare clone has no working tree, but it still has a full set of repository-internal files and directories sitting at its top level — `HEAD`, `config`, `description`, `hooks/`, `info/`, `objects/`, `packed-refs`, `refs/`. Clone straight into `my-repo/` and that's what ends up there:

```bash
$ git clone --bare <url> my-repo && ls -a my-repo
.  ..  HEAD  config  description  hooks  info  objects  packed-refs  refs
```

Every worktree you'd then add (`develop/`, `prod/`, `feature-x/`) lands as a sibling of `HEAD`/`objects`/`refs`/etc. — cluttered, and one bad worktree name away from colliding with a real git-internal path (try naming a branch dir `refs` or `objects`).

The fix: clone bare into a **hidden** subdirectory instead, `.bare/`, so all of that plumbing disappears from a normal `ls`:

```bash
$ ls -a my-repo
.  ..  .bare  .git  develop
```

Now `my-repo/` only ever shows things you actually care about — worktree directories — plus two dotfiles. That's the whole motivation: keep the project root clean and worktree-name-collision-free.

### What the `.git` file is for

Hiding the repo in `.bare/` creates a new problem: git commands run from `my-repo/` need to know where the repository actually is, since there's no `.git/` directory there anymore. The fix is the same mechanism git already uses for worktrees internally — a `.git` *file* (not a directory) containing a `gitdir:` pointer:

```text
$ cat my-repo/.git
gitdir: ./.bare
```

Any git command run inside `my-repo/` reads that file, follows the pointer to `.bare/`, and operates as if `.bare/` were a normal `.git/` directory right there. It's the identical trick each worktree's own `.git` file uses (pointing at `.bare/worktrees/<name>` instead) — the project root just reuses it to redirect straight at the bare repo itself.

Concretely, this is what `.git` and `.bare/` resolve to:

```text
my-repo/
├── .git             # file (not dir): "gitdir: ./.bare"
├── .bare/           # the actual repository — objects, refs, config, HEAD
├── develop/         # a worktree, added like any other via `git worktree add`
├── prod/            # another worktree
└── feature-x/       # another worktree
```

Now there is no "primary" checkout competing for a branch — the bare repo has no working tree of its own, so **every single branch you want to touch gets its own worktree, on equal footing.** `develop/` isn't special because it's "the clone"; it's special only because you chose to keep it around and lock it.

This repo automates both halves:

- `git bare-clone <url>` (`home/dot_local/bin/executable_git-bare-clone`) — does the bare clone + `.git` file setup, generically, for any repo.
- `git wt` (`home/dot_local/bin/executable_git-wt`) — the day-to-day layer on top: `git wt init` chains `git bare-clone` and adds **locked "fixed" worktrees** for long-lived branches (`develop`, `prod`), and `git wt new`/`review`/`done` manage **ephemeral worktrees** per task (one dir per feature/hotfix/PR-review, removed when finished).

Full command reference and gotchas (`.env*` copying, `node_modules` being per-worktree, etc.) are in `README.md` → "Git worktree workflow (`git-bare-clone`)" — this doc is the conceptual "why", that section is the practical "how".

## The gotcha: the project root has no branch of its own — but looks like it does

Since `my-repo/` (the root) resolves via its `.git` file straight to `.bare/`, and was never created by `git worktree add`, it isn't a registered worktree at all — it's the bare repo's own plumbing location. Running git commands there still "work" (git happily reads `.bare/HEAD` and answers), but that HEAD is just whatever branch was checked out at `git clone --bare` time — frozen, and unrelated to whichever worktree you actually intended to be in.

Confirmed by testing directly:

```bash
cd my-repo/            # the bare root, not a worktree
git rev-parse --is-bare-repository   # → true
git branch --show-current            # → whatever HEAD was at clone time, e.g. "develop"

cd my-repo/develop/     # an actual worktree
git rev-parse --is-bare-repository   # → false
git branch --show-current            # → develop (correct — this really is that worktree)
```

`git rev-parse --is-bare-repository` is the reliable signal: `true` only at the plumbing root, `false` inside every real worktree. That's exactly the distinction Starship's `git_branch` module has no way to make on its own — it just calls the equivalent of `git branch --show-current` and prints whatever comes back, so standing at the root **silently reported the frozen clone-time branch as if it were your current one.**

## The fix: `custom.git_branch` in `starship.toml`

`home/dot_config/starship.toml` disables the built-in `[git_branch]` module and replaces it with a `[custom.git_branch]` module that runs the same `--is-bare-repository` check and swaps in a `(bare)` marker instead of a branch name when it's true:

```toml
[custom.git_branch]
when = "git rev-parse --git-dir"
command = '''
if [ "$(git rev-parse --is-bare-repository 2>/dev/null)" = "true" ]; then
  echo "(bare)"
else
  git branch --show-current
fi
'''
format = "[$symbol$output]($style) "
```

Result: standing at `my-repo/` now shows `(bare)` — an unambiguous signal that you're in the plumbing directory, not on any branch — while every worktree underneath (`develop/`, `prod/`, `feature-x/`) shows its real, correct branch name as before.

## Takeaways

- Plain `git worktree add` is enough for occasional multi-branch work; reach for it directly, no scripts needed.
- The bare-clone pattern is worth it specifically when the workflow is "always work from worktrees, the root is never touched directly" — it removes the asymmetry between "the original clone" and "an added worktree".
- Any tool that reads git state (prompt, status line, editor plugin) needs its own bare-root detection if it's going to report anything at the plumbing root — `git rev-parse --is-bare-repository` is the check to reach for.
