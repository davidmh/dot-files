-- [nfnl] Compiled from fnl/own/string.fnl by https://github.com/Olical/nfnl, do not edit.
local function starts_with(text, prefix)
  return (string.sub(text, 0, #prefix) == prefix)
end
local function ends_with(str, suffix)
  return ((suffix == "") or (suffix == string.sub(str, ( - #suffix))))
end
local function format(str, tbl)
  local function _1_(param)
    return (tbl[string.sub(param, 3, -2)] or param)
  end
  return str:gsub("$%b{}", _1_)
end
return {["starts-with"] = starts_with, ["ends-with"] = ends_with, format = format}
