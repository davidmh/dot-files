local wezterm = require('wezterm')

return {
  font = wezterm.font('Hasklug Nerd Font'),
  font_size = 14.0,
  color_scheme = 'Catppuccin Macchiato',
  hide_tab_bar_if_only_one_tab = true,
  adjust_window_size_when_changing_font_size = false,
  audible_bell = 'Disabled',
  keys = {
    {
      key = 'n',
      mods = 'SHIFT|CTRL',
      action = 'ToggleFullScreen',
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
