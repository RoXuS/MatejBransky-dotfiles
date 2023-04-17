local wezterm = require("wezterm")
local color_mode = wezterm.gui.get_appearance()

local function resolve_appearance(options)
	if color_mode:find("Dark") then
		return options.dark
	else
		return options.light
	end
end

local tab_bar = resolve_appearance({
	light = {
		background = "#f0f0f0",

		active_tab = {
			bg_color = "#fcfcfc",
			fg_color = "#404040",
		},
		inactive_tab = {
			bg_color = "#f0f0f0",
			fg_color = "#999",
		},
		new_tab = {
			bg_color = "#f0f0f0",
			fg_color = "#000",
		},

		inactive_tab_hover = {
			bg_color = "#fcfcfc",
			fg_color = "#000",
		},
		new_tab_hover = {
			bg_color = "#ffffff",
			fg_color = "#000",
		},
	},
	dark = {
		background = "#282c34",

		active_tab = {
			bg_color = "#3b3f4c",
			fg_color = "#abb2bf",
		},
		inactive_tab = {
			bg_color = "#31353f",
			fg_color = "#abb2bf",
		},
		new_tab = {
			bg_color = "#282c34",
			fg_color = "#abb2bf",
		},

		inactive_tab_hover = {
			bg_color = "#3b3f4c",
			fg_color = "#abb2bf",
		},
		new_tab_hover = {
			bg_color = "#3b3f4c",
			fg_color = "#abb2bf",
		},
	},
})

return {
	color_scheme = resolve_appearance({
		light = "One Light (base16)",
		dark = "OneDark (base16)",
	}),
	font_size = 14,
	hide_tab_bar_if_only_one_tab = true,
	tab_bar_at_bottom = true,
	use_fancy_tab_bar = false,
	colors = {
		tab_bar = tab_bar,
	},
	initial_cols = 120,
	initial_rows = 40,
	window_decorations = "RESIZE",
}
