-- [nfnl] Compiled from fnl/plugins/ui.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local notify = autoload("notify")
local hover = autoload("hover")
local snacks = autoload("snacks")
local function _2_()
  notify.setup({timeout = 2500, minimum_width = 30, fps = 60, render = "wrapped-compact", top_down = false})
  vim.notify = notify
  return nil
end
local function _3_()
  require("hover.providers.diagnostic")
  require("hover.providers.lsp")
  require("hover.providers.jira")
  return require("hover.providers.fold_preview")
end
local function _4_()
  return hover.hover()
end
return {{"nvim-tree/nvim-web-devicons", config = true}, {"rcarriga/nvim-notify", event = "VeryLazy", config = _2_}, {"lewis6991/hover.nvim", opts = {init = _3_, preview_opts = {border = "rounded"}, preview_window = true, title = false}, keys = {{"K", _4_, mode = "n"}}}}
