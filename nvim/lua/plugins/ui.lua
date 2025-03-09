-- [nfnl] Compiled from fnl/plugins/ui.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local notify = autoload("notify")
local function _2_()
  notify.setup({timeout = 2500, minimum_width = 30, fps = 60, render = "wrapped-compact", top_down = false})
  vim.notify = notify
  return nil
end
local function _3_(_241, _242)
  return math.min(_242, 80)
end
local function _4_(_241, _242)
  return math.min(_242, 15)
end
return {{"nvim-tree/nvim-web-devicons", config = true}, {"rcarriga/nvim-notify", dependencies = {"nvim-telescope/telescope.nvim"}, event = "VeryLazy", config = _2_}, {"stevearc/dressing.nvim", event = "VeryLazy", opts = {select = {backend = "telescope"}, telescope = {layout_config = {width = _3_, height = _4_}}}}}
