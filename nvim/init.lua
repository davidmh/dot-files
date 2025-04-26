-- [nfnl] init.fnl
local _local_1_ = require("own.config")
local border = _local_1_["border"]
require("own.default-plugins")
require("own.bootstrap")
require("own.options")
local lazy = require("lazy")
lazy.setup("plugins", {dev = {path = (vim.env.HOME .. "/Projects"), fallback = true}, checker = {enabled = true, notify = false}, ui = {border = border, backdrop = 100}, rocks = {hererocks = true}})
local function _2_()
  require("own.mappings")
  require("own.projects")
  return require("own.sync-files")
end
return vim.schedule(_2_)
