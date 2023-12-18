-- [nfnl] Compiled from fnl/own/plugin/starter.fnl by https://github.com/Olical/nfnl, do not edit.
local starter = require("mini.starter")
local function _1_()
  local _2_ = {"fortune-kind", "-s"}
  if (nil ~= _2_) then
    local _3_ = vim.system(_2_, {text = true})
    if (nil ~= _3_) then
      local _4_ = _3_:wait()
      if (nil ~= _4_) then
        local _5_ = (_4_).stdout
        if (nil ~= _5_) then
          return string.gsub(_5_, "^1", "")
        else
          return _5_
        end
      else
        return _4_
      end
    else
      return _3_
    end
  else
    return _2_
  end
end
return starter.setup({header = _1_, items = {starter.sections.builtin_actions(), starter.sections.recent_files(7, false, false), starter.sections.telescope()}})
