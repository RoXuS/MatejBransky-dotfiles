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

local keys = create_pane_mappings({
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
})

table.insert(keys, {
	key = "P",
	mods = "CTRL",
	action = wezterm.action.QuickSelectArgs({
		patterns = {
			"https?://\\S+",
		},
		action = wezterm.action_callback(function(window, pane)
			local url = window:get_selection_text_for_pane(pane)
			wezterm.log_info("opening: " .. url)
			wezterm.open_with(url)
		end),
	}),
})

return keys
