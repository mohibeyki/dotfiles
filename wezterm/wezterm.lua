local wezterm = require("wezterm")

local config = wezterm.config_builder()

config.color_scheme = "Tokyo Night Storm"
config.font = wezterm.font("JetBrainsMono Nerd Font")
config.font_size = 14.0

return config
