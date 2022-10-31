-- import lualine plugin safely
local status, lualine = pcall(require, "lualine")
if not status then
	return
end

-- get lualine onenord theme
local lualine_onenord = require("lualine.themes.onenord")

-- new colors for theme
local new_colors = {
	blue = "#65D1FF",
	green = "#3EFFDC",
	violet = "#FF61EF",
	yellow = "#FFDA7B",
	black = "#000000",
}

-- change onenord theme colors
lualine_onenord.normal.a.bg = new_colors.blue
lualine_onenord.insert.a.bg = new_colors.green
lualine_onenord.visual.a.bg = new_colors.violet
lualine_onenord.command = {
	a = {
		gui = "bold",
		bg = new_colors.yellow,
		fg = new_colors.black, -- black
	},
}

-- configure lualine with modified theme
lualine.setup({
	options = {
    icons_enabled = true,
		theme = lualine_onenord,
	},
})
