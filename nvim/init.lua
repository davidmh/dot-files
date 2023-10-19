-- [nfnl] Compiled from init.fnl by https://github.com/Olical/nfnl, do not edit.
require("own.default-plugins")
require("own.bootstrap")
require("own.options")
require("own.plugins")
local function _1_()
  require("own.mappings")
  require("own.window-mappings")
  return require("own.package")
end
return vim.schedule(_1_)
