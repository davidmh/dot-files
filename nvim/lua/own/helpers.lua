-- [nfnl] Compiled from fnl/own/helpers.fnl by https://github.com/Olical/nfnl, do not edit.
local function window_size(window_id)
  return (vim.api.nvim_win_get_width(window_id) * vim.api.nvim_win_get_height(window_id))
end
local function get_largest_window_id()
  local windows_by_size = {}
  for _, window_id in pairs(vim.api.nvim_list_wins()) do
    windows_by_size[window_size(window_id)] = window_id
  end
  return windows_by_size[table.maxn(windows_by_size)]
end
return {["window-size"] = window_size, ["get-largest-window-id"] = get_largest_window_id}
