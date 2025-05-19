local wezterm = require('wezterm')

return {
  font = wezterm.font('Hasklug Nerd Font', { weight = 'Medium' }),
  font_size = 14.0,
  front_end = 'Software',
  color_scheme = 'Catppuccin Latte',
  line_height = 1.2,
  underline_position = -7,
  use_fancy_tab_bar = false,
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

    {
      key = 'd',
      mods = 'SHIFT|CTRL',
      action = wezterm.action.DetachDomain('CurrentPaneDomain'),
    },
  },
  window_decorations = 'RESIZE',
  window_close_confirmation = 'NeverPrompt',
}
