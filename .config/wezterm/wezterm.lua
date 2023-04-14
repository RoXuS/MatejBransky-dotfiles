local wezterm = require("wezterm")

local function create_pane_mappings(config)
	local focus_action = {
		up = wezterm.action.ActivatePaneDirection("Up"),
		down = wezterm.action.ActivatePaneDirection("Down"),
		left = wezterm.action.ActivatePaneDirection("Left"),
		right = wezterm.action.ActivatePaneDirection("Right"),
	}
	local split_action = {
		up = wezterm.action.SplitPane({ direction = "Up" }),
		down = wezterm.action.SplitPane({ direction = "Down" }),
		left = wezterm.action.SplitPane({ direction = "Left" }),
		right = wezterm.action.SplitPane({ direction = "Right" }),
	}
	local resize_action = {
		up = wezterm.action.AdjustPaneSize({ "Up", 5 }),
		down = wezterm.action.AdjustPaneSize({ "Down", 5 }),
		left = wezterm.action.AdjustPaneSize({ "Left", 5 }),
		right = wezterm.action.AdjustPaneSize({ "Right", 5 }),
	}
	local mods = config.mods
	local keys = config.keys
	local mappings = {}
	for direction, key in pairs(keys) do
		table.insert(mappings, {
			key = key,
			mods = mods.focus,
			action = focus_action[direction],
		})
		table.insert(mappings, {
			key = key,
			mods = mods.split,
			action = split_action[direction],
		})
		table.insert(mappings, {
			key = key,
			mods = mods.resize,
			action = resize_action[direction],
		})
	end
	return mappings
end

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return "OneDark (base16)"
	else
		return "One Light (base16)"
	end
end

return {
	color_scheme = scheme_for_appearance(wezterm.gui.get_appearance()),
	font_size = 14,
	hide_tab_bar_if_only_one_tab = true,
	initial_cols = 120,
	initial_rows = 40,
	use_fancy_tab_bar = false,
	window_decorations = "RESIZE",
	keys = create_pane_mappings({
		mods = {
			focus = "SUPER",
			split = "CTRL|SUPER",
			resize = "META|SUPER",
		},
		keys = {
			up = "k",
			down = "j",
			left = "h",
			right = "l",
		},
	}),
}
