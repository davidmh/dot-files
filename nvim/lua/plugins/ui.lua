-- [nfnl] Compiled from fnl/plugins/ui.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local hover = autoload("hover")
local function _2_()
  require("hover.providers.diagnostic")
  require("hover.providers.lsp")
  require("hover.providers.jira")
  return require("hover.providers.fold_preview")
end
local function _3_()
  return hover.hover()
end
return {{"nvim-tree/nvim-web-devicons", config = true}, {"lewis6991/hover.nvim", opts = {init = _2_, preview_opts = {border = "rounded"}, preview_window = true, title = false}, keys = {{"K", _3_, mode = "n"}}}}
