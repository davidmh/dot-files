-- [nfnl] Compiled from after/ftplugin/fugitive.fnl by https://github.com/Olical/nfnl, do not edit.
local padding = 2
local buffer_line_count = (vim.fn.line("$") + padding)
local minimum_window_height = 10
return vim.api.nvim_win_set_height(0, math.max(math.min(vim.fn.winheight(0), buffer_line_count), minimum_window_height))
