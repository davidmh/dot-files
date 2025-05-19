-- [nfnl] fnl/own/helpers.fnl
local _local_1_ = require("nfnl.module")
local define = _local_1_["define"]
local M = define("own.helpers")
M["window-size"] = function(window_id)
  return (vim.api.nvim_win_get_width(window_id) * vim.api.nvim_win_get_height(window_id))
end
M["get-largest-window-id"] = function()
  local windows_by_size = {}
  for _, window_id in pairs(vim.api.nvim_list_wins()) do
    windows_by_size[M["window-size"](window_id)] = window_id
  end
  return windows_by_size[table.maxn(windows_by_size)]
end
M["sanitize-path"] = function(path, size)
  return vim.fn.pathshorten(string.gsub(string.gsub(path, vim.env.HOME, "~"), vim.env.REMIX_HOME, "remix"), (size or 2))
end
M["find-root"] = function(pattern)
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
return M
