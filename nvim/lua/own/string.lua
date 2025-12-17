-- [nfnl] fnl/own/string.fnl
local _local_1_ = require("nfnl.module")
local define = _local_1_.define
local M = define("own.string")
M.format = function(str, tbl)
  local function _2_(param)
    return (tbl[string.sub(param, 3, -2)] or param)
  end
  return str:gsub("$%b{}", _2_)
end
return M
