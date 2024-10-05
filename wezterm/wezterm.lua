local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.color_scheme = "Tokyo Night"
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 14.0

config.window_decorations = "TITLE | RESIZE"
config.window_close_confirmation = "NeverPrompt"
config.scrollback_lines = 3000
config.enable_scroll_bar = true
config.default_workspace = "home"
config.native_macos_fullscreen_mode = true
config.hide_tab_bar_if_only_one_tab = true

config.keys = {
	{
		key = "Enter",
		mods = "CMD",
		action = wezterm.action.ToggleFullScreen,
	},
}

return config
