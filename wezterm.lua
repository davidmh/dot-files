local wezterm = require('wezterm')
local mux = wezterm.mux

local function get_color_scheme(pane)
  local flavor = pane:get_user_vars().CATPPUCCIN_FLAVOR or 'Latte'
  return 'Catppuccin ' .. flavor
end

local function set_color_scheme(window, pane)
  local color_scheme = get_color_scheme(pane)

  window:set_config_overrides({ color_scheme = color_scheme })
end

wezterm.on('window-focus-changed', set_color_scheme)

wezterm.on('gui-startup', function(cmd)
  local _, pane, window = mux.spawn_window(cmd or {})
  set_color_scheme(window, pane)
end)

return {
  font = wezterm.font('Dank Mono'),
  font_size = 14.0,
  color_scheme = 'Catppuccin Macchiato',
  hide_tab_bar_if_only_one_tab = true,
  keys = {
    {
      key = 'n',
      mods = 'SHIFT|CTRL',
      action = 'ToggleFullScreen'
    },
    {
      key = ' ',
      mods = 'CTRL',
      action = 'QuickSelect',
    },
    {
      key = 'r',
      mods = 'CMD',
      action = 'ReloadConfiguration',
    },
  },
  window_decorations = 'RESIZE',
}
