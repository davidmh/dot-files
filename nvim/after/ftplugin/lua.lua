-- [nfnl] Compiled from after/ftplugin/lua.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("own.string")
local starts_with = _local_1_["starts-with"]
require("own.fennel-lua-paths"):setup()
if starts_with(vim.fn.expand("%:p"), (vim.env.HOME .. "/.config/home-manager/nvim")) then
  vim.bo.readonly = true
  return nil
else
  return nil
end
