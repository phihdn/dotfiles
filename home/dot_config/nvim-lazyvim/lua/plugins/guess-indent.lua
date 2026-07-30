-- LazyVim hardcodes tabstop/shiftwidth=2 + expandtab for every buffer, so
-- files that actually use tabs or 4-space indent render misaligned with the
-- indent guides (VS Code/Cursor auto-detects this). guess-indent inspects
-- each opened file and sets buffer-local indent options to match it.
-- :GuessIndent to re-run manually if a buffer guesses wrong.
return {
  "nmac427/guess-indent.nvim",
  event = { "BufReadPost", "BufNewFile" },
  opts = {},
}
