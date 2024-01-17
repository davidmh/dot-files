local wezterm = require('wezterm')

-- zen-mode.nvim
wezterm.on('user-var-changed', function(window, pane, name, value)
  local overrides = window:get_config_overrides() or {}
  if name == 'ZEN_MODE' then
    local incremental = value:find('+')
    local number_value = tonumber(value)
    if incremental ~= nil then
      while number_value > 0 do
        window:perform_action(wezterm.action.IncreaseFontSize, pane)
        number_value = number_value - 1
      end
      overrides.enable_tab_bar = false
    elseif number_value < 0 then
      window:perform_action(wezterm.action.ResetFontSize, pane)
      overrides.font_size = nil
      overrides.enable_tab_bar = true
    else
      overrides.font_size = number_value
      overrides.enable_tab_bar = false
    end
  end
  window:set_config_overrides(overrides)
end)

return {
  font = wezterm.font('Hasklug Nerd Font', { weight = 'Medium' }),
  font_size = 14.0,
  front_end = 'Software',
  color_scheme = 'Catppuccin Mocha',
  line_height = 1.3,
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
