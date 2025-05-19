-- [nfnl] fnl/own/mode.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local define = _local_1_["define"]
local palettes = autoload("catppuccin.palettes")
local M = define("own.mode")
local mode_label = {n = "NORMAL", i = "INSERT", v = "VISUAL", V = "V-LINE", ["\22"] = "V-BLOCK", c = "COMMAND", s = "SELECT", S = "S-LINE", ["\19"] = "S-BLOCK", R = "REPLACE", r = "REPLACE", ["!"] = "SHELL", t = "TERMINAL", nt = "T-NORMAL"}
local mode_colors = {n = "text", i = "green", v = "sky", V = "teal", ["\22"] = "teal", c = "flamingo", s = "mauve", S = "mauve", ["\19"] = "mauve", R = "flamingo", r = "flamingo", ["!"] = "red", t = "green", nt = "text"}
M["get-color"] = function()
  local palette = palettes.get_palette()
  local mode = vim.fn.mode(1)
  local color_name = mode_colors[mode]
  return palette[color_name]
end
M["get-label"] = function()
  local mode = vim.fn.mode(1)
  return (mode_label[mode] or mode)
end
return M
