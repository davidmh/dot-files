-- [nfnl] fnl/own/string.fnl
local function format(str, tbl)
  local function _1_(param)
    return (tbl[string.sub(param, 3, -2)] or param)
  end
  return str:gsub("$%b{}", _1_)
end
return {format = format}
