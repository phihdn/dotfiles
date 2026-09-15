vim.opt.termguicolors = true

-- Swapped from the upstream author's rose-pine to Kanagawa Dragon.
-- To go back: comment out the kanagawa block and uncomment the rose-pine one
-- (both plugins are already in lua/plugins/init.lua, nothing to re-download).
require("kanagawa").setup({
	theme = "dragon",
	background = { dark = "dragon" },
	transparent = true,
	overrides = function(colors)
		local theme = colors.theme
		return {
			-- upstream kept inlay hints dim and italic against the editor bg
			LspInlayHint = { bg = theme.ui.bg, fg = theme.ui.nontext, italic = true },
			NotificationInfo = { bg = "none", fg = theme.ui.fg },
			NotificationWarning = { bg = "none", fg = theme.ui.fg_dim },
			NotificationError = { bg = "none", fg = theme.diag.error },
		}
	end,
})
vim.cmd("colorscheme kanagawa-dragon")

-- -- Upstream default:
-- require("rose-pine").setup({
-- 	styles = { bold = false, italic = false, transparency = true },
-- 	highlight_groups = {
-- 		LspInlayHint = { bg = "base", fg = "muted", italic = true },
-- 		NotificationInfo = { bg = "none", fg = "text" },
-- 		NotificationWarning = { bg = "none", fg = "subtle" },
-- 		NotificationError = { bg = "none", fg = "love" },
-- 	},
-- })
-- vim.cmd("colorscheme rose-pine")
