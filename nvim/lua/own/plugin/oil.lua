-- [nfnl] Compiled from fnl/own/plugin/oil.fnl by https://github.com/Olical/nfnl, do not edit.
local oil = require("oil")
oil.setup({view_options = {show_hidden = true}})
local function _1_()
  vim.cmd("split")
  return oil.open()
end
vim.keymap.set("n", "-", _1_)
local function _2_()
  vim.cmd("vsplit")
  return oil.open()
end
return vim.keymap.set("n", "\\", _2_)
