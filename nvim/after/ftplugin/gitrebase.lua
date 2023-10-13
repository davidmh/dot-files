-- [nfnl] Compiled from after/ftplugin/gitrebase.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("own.string")
local starts_with = _local_1_["starts-with"]
local _local_2_ = require("own.lists")
local find_index = _local_2_["find-index"]
local actions = {"pick", "reword", "edit", "squash", "fixup", "break", "drop"}
local function cycle()
  local current_line = vim.api.nvim_get_current_line()
  local current_index
  local function _3_(_241)
    return starts_with(current_line, _241)
  end
  current_index = find_index(_3_, actions)
  if current_index then
    local current_action = ("^" .. actions[current_index])
    local next_action = (actions[(current_index + 1)] or actions[1])
    local next_line = string.gsub(current_line, current_action, next_action)
    return vim.api.nvim_set_current_line(next_line)
  else
    return nil
  end
end
return vim.keymap.set("n", "<tab>", cycle, {silent = true, nowait = true, buffer = 0})
