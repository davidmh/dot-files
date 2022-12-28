local wezterm = require('wezterm')

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
