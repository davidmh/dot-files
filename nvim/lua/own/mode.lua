-- [nfnl] fnl/own/mode.fnl
local _local_1_ = require("nfnl.module")
local define = _local_1_.define
local M = define("own.mode")
local mode_label = {n = "NORMAL", i = "INSERT", v = "VISUAL", V = "V-LINE", ["\22"] = "V-BLOCK", c = "COMMAND", s = "SELECT", S = "S-LINE", ["\19"] = "S-BLOCK", R = "REPLACE", r = "REPLACE", ["!"] = "SHELL", t = "TERMINAL", nt = "T-NORMAL"}
local mode_colors = {n = "fg", i = "lotusGreen", v = "blue", V = "lotusTeal1", ["\22"] = "lotusTeal1", c = "sakuraPink", s = "purple", S = "purple", ["\19"] = "purple", R = "sakuraPink", r = "sakuraPink", ["!"] = "red", t = "lotusGreen", nt = "fg"}
M["get-color"] = function()
  local mode = vim.fn.mode(1)
  return mode_colors[mode]
end
M["get-label"] = function()
  local mode = vim.fn.mode(1)
  return (mode_label[mode] or mode)
end
return M
