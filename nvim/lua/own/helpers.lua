-- [nfnl] fnl/own/helpers.fnl
local _local_1_ = require("nfnl.module")
local define = _local_1_.define
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
  return vim.fn.pathshorten(string.gsub(path, vim.env.HOME, "~"), (size or 2))
end
M["past-due?"] = function(iso_date)
  vim.validate("iso-date", iso_date, "string")
  local year, month, day = iso_date:match("(%d+)-(%d+)-(%d+)")
  return (os.time() >= os.time({year = year, month = month, day = day}))
end
return M
