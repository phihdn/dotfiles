--
-- ██╗    ██╗███████╗███████╗████████╗███████╗██████╗ ███╗   ███╗
-- ██║    ██║██╔════╝╚══███╔╝╚══██╔══╝██╔════╝██╔══██╗████╗ ████║
-- ██║ █╗ ██║█████╗    ███╔╝    ██║   █████╗  ██████╔╝██╔████╔██║
-- ██║███╗██║██╔══╝   ███╔╝     ██║   ██╔══╝  ██╔══██╗██║╚██╔╝██║
-- ╚███╔███╔╝███████╗███████╗   ██║   ███████╗██║  ██║██║ ╚═╝ ██║
--  ╚══╝╚══╝ ╚══════╝╚══════╝   ╚═╝   ╚══════╝╚═╝  ╚═╝╚═╝     ╚═╝
-- A GPU-accelerated cross-platform terminal emulator
-- https://wezfurlong.org/wezterm/

local k = require("utils/keys")

local wezterm = require("wezterm")
local act = wezterm.action

local config = {
	-- font
	font = wezterm.font_with_fallback({
		-- "Liga SFMono Nerd Font",
		-- "Fira Code",
		-- "JetBrains Mono",
		"CommitMono Nerd Font",
		{ family = "Symbols Nerd Font Mono" },
		-- { family = "Symbols Nerd Font Mono", scale = 1.0 },
	}),
	font_size = 20,
	line_height = 1.4,

	-- colors — Catppuccin Mocha (canonical hex, inline so it matches exactly
	-- rather than relying on a bundled scheme's approximation)
	-- https://github.com/catppuccin/wezterm
	colors = {
		foreground = "#cdd6f4",
		background = "#1e1e2e",
		cursor_bg = "#f5e0dc",
		cursor_fg = "#1e1e2e",
		cursor_border = "#f5e0dc",
		selection_fg = "#cdd6f4",
		selection_bg = "#585b70",
		-- Mocha defines one value per hue — ansi and brights share it, unlike gruvbox
		ansi = {
			"#45475a",
			"#f38ba8",
			"#a6e3a1",
			"#f9e2af",
			"#89b4fa",
			"#f5c2e7",
			"#94e2d5",
			"#bac2de",
		},
		brights = {
			"#585b70",
			"#f38ba8",
			"#a6e3a1",
			"#f9e2af",
			"#89b4fa",
			"#f5c2e7",
			"#94e2d5",
			"#a6adc8",
		},
	},

	window_background_opacity = 0.80,
	inactive_pane_hsb = {
		hue = 0.0,
		saturation = 0.0,
		brightness = 0.0,
	},
	text_background_opacity = 1.0,

	-- padding
	window_padding = {
		left = 12,
		right = 12,
		top = 12,
		bottom = 0,
	},

	set_environment_variables = {
		-- THEME_FLAVOUR = "latte",
		-- BAT_THEME = "Catppuccin-mocha",
		-- BAT_THEME = "gruvbox-dark",
		LC_ALL = "en_US.UTF-8",
	},

	-- general options
	adjust_window_size_when_changing_font_size = false,
	debug_key_events = false,
	enable_tab_bar = false,
	native_macos_fullscreen_mode = false,
	window_close_confirmation = "NeverPrompt",
	window_decorations = "RESIZE",
	audible_bell = "Disabled",

	-- keys
	keys = {
		k.cmd_key(".", k.multiple_actions(":ZenMode")),
		k.cmd_key("[", act.SendKey({ mods = "CTRL", key = "o" })),
		k.cmd_key("]", act.SendKey({ mods = "CTRL", key = "i" })),
		k.cmd_key("f", k.multiple_actions(":Grep")),
		-- k.cmd_key("H", act.SendKey({ mods = "CTRL", key = "h" })),
		k.cmd_key("i", k.multiple_actions(":SmartGoTo")),
		-- k.cmd_key("J", act.SendKey({ mods = "CTRL", key = "j" })),
		-- k.cmd_key("K", act.SendKey({ mods = "CTRL", key = "k" })),
		-- k.cmd_key("K", act.SendKey({ mods = "CTRL", key = "k" })),
		-- k.cmd_key("L", act.SendKey({ mods = "CTRL", key = "l" })),
		k.cmd_key("O", k.multiple_actions(":GoToSymbol")),
		k.cmd_key("P", k.multiple_actions(":GoToCommand")),
		k.cmd_key("p", k.multiple_actions(":GoToFile")),
		-- k.cmd_key("q", k.multiple_actions(":qa!")),
		k.cmd_to_tmux_prefix("1", "1"),
		k.cmd_to_tmux_prefix("2", "2"),
		k.cmd_to_tmux_prefix("3", "3"),
		k.cmd_to_tmux_prefix("4", "4"),
		k.cmd_to_tmux_prefix("5", "5"),
		k.cmd_to_tmux_prefix("6", "6"),
		k.cmd_to_tmux_prefix("7", "7"),
		k.cmd_to_tmux_prefix("8", "8"),
		k.cmd_to_tmux_prefix("9", "9"),
		k.cmd_to_tmux_prefix("`", "n"),
		k.cmd_to_tmux_prefix("b", "b"),
		k.cmd_to_tmux_prefix("C", "C"),
		k.cmd_to_tmux_prefix("d", "D"),
		k.cmd_to_tmux_prefix("G", "G"),
		k.cmd_to_tmux_prefix("g", "g"),
		k.cmd_to_tmux_prefix("j", "J"),
		k.cmd_to_tmux_prefix("K", "R"),
		k.cmd_to_tmux_prefix("k", "K"),
		k.cmd_to_tmux_prefix("l", "L"),
		k.cmd_to_tmux_prefix("n", "%"),
		k.cmd_to_tmux_prefix("N", '"'),
		k.cmd_to_tmux_prefix("o", "u"),
		k.cmd_to_tmux_prefix("T", "B"),
		k.cmd_to_tmux_prefix("Y", "Y"),
		k.cmd_to_tmux_prefix("t", "c"),
		k.cmd_to_tmux_prefix("w", "x"),
		k.cmd_to_tmux_prefix("z", "z"),
		k.cmd_to_tmux_prefix("Z", "Z"),
		k.cmd_to_tmux_prefix("9", "9"),
		k.cmd_ctrl_to_tmux_prefix("t", "J"),

		k.cmd_key(
			"R",
			act.Multiple({
				act.SendKey({ key = "\x1b" }), -- escape
				k.multiple_actions(":source %"),
			})
		),

		k.cmd_key(
			"s",
			act.Multiple({
				act.SendKey({ key = "\x1b" }), -- escape
				k.multiple_actions(":w"),
			})
		),

		{
			mods = "CMD|SHIFT",
			key = "}",
			action = act.Multiple({
				act.SendKey({ mods = "CTRL", key = "a" }),
				act.SendKey({ key = "n" }),
			}),
		},
		{
			mods = "CMD|SHIFT",
			key = "{",
			action = act.Multiple({
				act.SendKey({ mods = "CTRL", key = "a" }),
				act.SendKey({ key = "p" }),
			}),
		},

		{
			mods = "CTRL",
			key = "Tab",
			action = act.Multiple({
				act.SendKey({ mods = "CTRL", key = "a" }),
				act.SendKey({ key = "n" }),
			}),
		},

		{
			mods = "CTRL|SHIFT",
			key = "Tab",
			action = act.Multiple({
				act.SendKey({ mods = "CTRL", key = "a" }),
				act.SendKey({ key = "n" }),
			}),
		},

		-- FIX: disable binding
		-- {
		-- 	mods = "CMD",
		-- 	key = "`",
		-- 	action = act.Multiple({
		-- 		act.SendKey({ mods = "CTRL", key = "a" }),
		-- 		act.SendKey({ key = "n" }),
		-- 	}),
		-- },

		{
			mods = "CMD",
			key = "~",
			action = act.Multiple({
				act.SendKey({ mods = "CTRL", key = "a" }),
				act.SendKey({ key = "p" }),
			}),
		},
	},
	mouse_bindings = {
		-- Ctrl-click will open the link under the mouse cursor
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "CTRL",
			action = wezterm.action.OpenLinkAtMouseCursor,
		},
		{
			event = { Up = { streak = 1, button = "Left" } },
			mods = "NONE",
			action = wezterm.action({ CompleteSelectionOrOpenLinkAtMouseCursor = "Clipboard" }),
			-- NOTE: the default action is:
			-- action=wezterm.action{CompleteSelectionOrOpenLinkAtMouseCursor="PrimarySelection"},
		},
	},
}

return config
