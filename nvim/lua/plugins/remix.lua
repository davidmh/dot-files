-- [nfnl] fnl/plugins/remix.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local actions = autoload("remix.actions")
local function _2_()
  return actions.select()
end
return {"remix", dir = (vim.env.REMIX_HOME .. "/.nvim"), keys = {{"<localleader>r", _2_, mode = "n"}}, name = "remix", opts = {}}
