-- [nfnl] fnl/plugins/glance.fnl
local core = require("nfnl.core")
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local glance = autoload("glance")
local mappings
local function _2_()
  return glance.actions.quickfix()
end
local function _3_()
  return glance.actions.next_location()
end
local function _4_()
  return glance.actions.previous_location()
end
local function _5_()
  return glance.actions.jump_vsplit()
end
local function _6_()
  return glance.actions.jump_split()
end
mappings = {["<c-q>"] = _2_, ["<c-n>"] = _3_, ["<c-p>"] = _4_, ["<c-v>"] = _5_, ["<c-x>"] = _6_}
local function _7_(results, open_preview, jump_to_result)
  local _8_ = #results
  if (_8_ == 0) then
    return vim.notify("No results found")
  elseif (_8_ == 1) then
    jump_to_result(core.first(results))
    return vim.cmd({cmd = "normal", args = {"zz"}, bang = true})
  else
    local _ = _8_
    return open_preview(results)
  end
end
return {"dnlhc/glance.nvim", cmd = "Glance", opts = {mappings = {list = mappings, preview = mappings}, hooks = {before_open = _7_}}}
