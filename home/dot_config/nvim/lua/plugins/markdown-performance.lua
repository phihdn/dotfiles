-- Fix laggy j/k scrolling in markdown buffers. Two sources of per-keystroke
-- work, both scoped to markdown so other filetypes keep LazyVim defaults:
--
-- 1. render-markdown's anti_conceal re-renders the cursor line on every
--    CursorMoved (clear marks on the line entered, restore on the line left).
--    Disabling it keeps decorations static; raw markdown still shows when
--    entering insert mode, since rendering pauses outside normal mode.
-- 2. snacks.nvim scroll animation (on by default in LazyVim) queues an
--    animation per scroll step, which stacks up when holding j/k at the
--    window edge on top of render-markdown's redraws.
return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    optional = true,
    opts = {
      anti_conceal = { enabled = false },
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("markdown_disable_scroll_animation", { clear = true }),
        pattern = { "markdown", "markdown.mdx" },
        callback = function()
          vim.b.snacks_scroll = false
        end,
      })
    end,
  },
}
