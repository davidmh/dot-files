-- [nfnl] fnl/own/commands.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local git = autoload("own.git")
local function _2_()
  return git["copy-remote-url"]()
end
return vim.api.nvim_create_user_command("GCopy", _2_, {range = true, nargs = 0})
