local wezterm = require 'wezterm'

local function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    return 'OneDark (base16)'
  else
    return 'One Light (base16)'
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
}
