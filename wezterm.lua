local wezterm = require('wezterm')
local appearance = wezterm.gui.get_appearance()
local is_dark = appearance:find "Dark"

local color_scheme = "Catppuccin Latte"

if is_dark then
  color_scheme = "Catppuccin Macchiato"
end

return {
  font = wezterm.font("Dank Mono"),
  font_size = 18.0,
  color_scheme = color_scheme,
  hide_tab_bar_if_only_one_tab = true,
  keys = {
    {key="n", mods="SHIFT|CTRL", action="ToggleFullScreen"},
  },
  window_decorations = "RESIZE",
}
