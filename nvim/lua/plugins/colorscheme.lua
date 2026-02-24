-- [nfnl] fnl/plugins/colorscheme.fnl
local colors = require("own.colors")
local function _1_()
  return vim.cmd.colorscheme("kanagawa")
end
return {"rebelot/kanagawa.nvim", init = _1_, opts = {colors = {theme = {all = {ui = {bg_gutter = "none"}}}}, overrides = colors["get-highlights"]}}
