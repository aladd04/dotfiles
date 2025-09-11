-- How to edit: https://wezterm.org/config/files.html

local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font_size = 14
config.font = wezterm.font("MonaspiceNe Nerd Font")

config.color_scheme = "Catppuccin Mocha"

-- config.window_decorations = "RESIZE"
config.enable_tab_bar = false

return config
