-- [nfnl] Compiled from init.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("own.config")
local border = _local_1_["border"]
require("own.default-plugins")
require("own.bootstrap")
require("own.options")
local lazy = require("lazy")
lazy.setup("plugins", {dev = {path = (vim.env.HOME .. "/Projects")}, fallback = true, ui = {border = border}})
local function _2_()
  require("own.mappings")
  return require("own.package")
end
return vim.schedule(_2_)
