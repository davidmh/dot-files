-- [nfnl] fnl/own/helpers.fnl
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
local function sanitize_path(path, size)
  return vim.fn.pathshorten(string.gsub(string.gsub(path, vim.env.HOME, "~"), vim.env.REMIX_HOME, "remix"), (size or 2))
end
local function find_root(pattern)
  local Path = require("plenary.path")
  local function finder(staring_path)
    for dir in vim.fs.parents(staring_path) do
      local path = Path:new((dir .. "/" .. pattern))
      if path:exists() then
        return dir
      else
      end
    end
    return nil
  end
  return finder
end
return {["window-size"] = window_size, ["get-largest-window-id"] = get_largest_window_id, ["sanitize-path"] = sanitize_path, ["find-root"] = find_root}
