-- [nfnl] Compiled from fnl/plugins/ui.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local notify = autoload("notify")
local function _2_(_241, _242)
  return math.min(_242, 80)
end
local function _3_(_241, _242)
  return math.min(_242, 15)
end
local function _4_()
  notify.setup({timeout = 2500, minimum_width = 30, fps = 60, render = "wrapped-compact", top_down = false})
  vim.notify = notify
  return nil
end
return {{"nvim-tree/nvim-web-devicons", opts = {override = {scm = {color = "#A6E3A1", name = "query", icon = "\243\176\152\167"}, fnl = {color = "teal", name = "blue", icon = "\238\143\146"}, norg = {icon = "\238\152\179"}}}, config = true}, {"nvim-zh/colorful-winsep.nvim", config = true, event = {"WinLeave"}}, {"stevearc/dressing.nvim", event = "VeryLazy", opts = {select = {backend = "telescope"}, telescope = {layout_config = {width = _2_, height = _3_}}}}, {"rcarriga/nvim-notify", dependencies = {"nvim-telescope/telescope.nvim"}, event = "VeryLazy", config = _4_}}
