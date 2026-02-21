-- [nfnl] fnl/own/mode.fnl
local _local_1_ = require("nfnl.module")
local define = _local_1_.define
local M = define("own.mode")
local mode_label = {n = "NORMAL", i = "INSERT", v = "VISUAL", V = "V-LINE", ["\22"] = "V-BLOCK", c = "COMMAND", s = "SELECT", S = "S-LINE", ["\19"] = "S-BLOCK", R = "REPLACE", r = "REPLACE", ["!"] = "SHELL", t = "TERMINAL", nt = "T-NORMAL"}
local mode_colors = {n = "modeNormal", i = "modeInsert", v = "modeVisual", V = "modeVLine", ["\22"] = "modeVBlock", c = "modeCommand", s = "modeSelect", S = "modeSLine", ["\19"] = "modeSBlock", R = "modeReplace", r = "modeReplace", ["!"] = "modeShellCmd", t = "modeTerm", nt = "modeNormalTerm"}
M["get-color"] = function()
  local mode = vim.fn.mode(1)
  return mode_colors[mode]
end
M["get-label"] = function()
  local mode = vim.fn.mode(1)
  return (mode_label[mode] or mode)
end
return M
