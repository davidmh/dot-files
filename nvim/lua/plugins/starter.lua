-- [nfnl] Compiled from fnl/plugins/starter.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local mini_starter = autoload("mini.starter")
local projects = autoload("own.projects")
local config
local function _2_()
  return mini_starter.setup({header = "", items = {projects["recent-projects"](), mini_starter.sections.recent_files(10, false, true), mini_starter.sections.builtin_actions()}, footer = ""})
end
config = _2_
local function _3_()
  return mini_starter.open()
end
return {"echasnovski/mini.starter", version = "*", event = "VimEnter", config = config, keys = {{"<localleader>s", _3_, desc = "Open Starter"}}}
