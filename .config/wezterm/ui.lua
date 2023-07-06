local wezterm = require("wezterm")
local color_mode = wezterm.gui.get_appearance()

local function resolve_appearance(options)
	if color_mode:find("Dark") then
		return options.dark
	else
		return options.light
	end
end

local function resolve_tab_bar(options)
	local theme = resolve_appearance({ light = options.lightTheme, dark = options.darkTheme })

	local output = {
		background = theme.bg,

		active_tab = {
			bg_color = theme.bg,
			fg_color = theme.fg_active,
		},
		inactive_tab = {
			bg_color = theme.bg,
			fg_color = theme.fg_inactive,
		},
		new_tab = {
			bg_color = theme.bg,
			fg_color = theme.fg_inactive,
		},

		inactive_tab_hover = {
			bg_color = theme.bg,
			fg_color = theme.fg_hover,
		},
		new_tab_hover = {
			bg_color = theme.bg,
			fg_color = theme.fg_hover,
		},
	}

	return output
end

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
		tab_bar = resolve_tab_bar({
			lightTheme = {
				bg = "#fcfcfc",
				fg_inactive = "#a0a1a7",
				fg_active = "#383a42",
				fg_hover = "#818387",
			},
			darkTheme = {
				bg = "#282c34",
				fg_inactive = "#848b98",
				fg_active = "#e2b86b",
				fg_hover = "#abb2bf",
			},
		}),
	},
	initial_cols = 120,
	initial_rows = 40,
	window_decorations = "RESIZE",
}
