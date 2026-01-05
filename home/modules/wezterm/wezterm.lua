local wezterm = require("wezterm")
local act = wezterm.action

local config = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

-- Settings
config.window_background_opacity = 0.9
config.window_decorations = "TITLE | RESIZE"
config.initial_rows = 32
config.initial_cols = 140
config.window_close_confirmation = "AlwaysPrompt"
config.scrollback_lines = 3000
config.default_workspace = "home"
config.enable_kitty_graphics = true
config.default_cwd = wezterm.home_dir

-- Keys
config.leader = { key = "a", mods = "CTRL", timeout_millisecconds = 1000 }
config.keys = {
	-- Send C-a when pressing C-a twice
	{ key = "a", mods = "LEADER", action = act.SendKey({ key = "a", mods = "CTRL" }) },
}

-- Tab bar
config.use_fancy_tab_bar = false
config.status_update_interval = 1000
