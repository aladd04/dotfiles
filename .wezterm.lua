-- How to edit: https://wezterm.org/config/files.html

local wezterm = require("wezterm")
local config = wezterm.config_builder()

config.font_size = 14
config.font = wezterm.font("MonaspiceNe Nerd Font")

config.color_scheme = "Catppuccin Mocha"

-- config.window_decorations = "RESIZE"
config.enable_tab_bar = false

-- similar setup to my tmux, but with 'a' instead of 'b'
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 5000 }
config.keys = {
	{
		key = "b",
		mods = "LEADER|CTRL",
		action = wezterm.action.SendKey({ key = "b", mods = "CTRL" }),
	},
	{
		key = "\\",
		mods = "LEADER",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "-",
		mods = "LEADER",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "h",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Left"),
	},
	{
		key = "l",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Right"),
	},
	{
		key = "k",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Up"),
	},
	{
		key = "j",
		mods = "LEADER",
		action = wezterm.action.ActivatePaneDirection("Down"),
	},
}

return config
