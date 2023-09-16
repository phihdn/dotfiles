-- Pull in the wezterm API
local wezterm = require("wezterm")

-- This table will hold the configuration.
local config = {}

-- In newer versions of wezterm, use the config_builder which will
-- help provide clearer error messages
if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = "Catppuccin Macchiato"

config.font = wezterm.font_with_fallback({
	"JetBrainsMono Nerd Font",
	{ family = "Symbols Nerd Font Mono", scale = 1.0 },
})

config.window_background_opacity = 0.8
config.macos_window_background_blur = 10
config.force_reverse_video_cursor = true
config.window_decorations = "RESIZE"
config.use_cap_height_to_scale_fallback_fonts = true
config.font_size = 22
config.scrollback_lines = 5000
config.hide_tab_bar_if_only_one_tab = true
config.window_close_confirmation = "NeverPrompt"
config.window_padding = { left = 14, right = 14, top = 10, bottom = 10 }
config.send_composed_key_when_left_alt_is_pressed = false
config.send_composed_key_when_right_alt_is_pressed = true
config.adjust_window_size_when_changing_font_size = false
config.warn_about_missing_glyphs = true

config.keys = {
	{ mods = "CTRL", key = "V", action = wezterm.action.PasteFrom("Clipboard") },
}

-- and finally, return the configuration to wezterm
return config
