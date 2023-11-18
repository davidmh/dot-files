-- [nfnl] Compiled from fnl/own/string.fnl by https://github.com/Olical/nfnl, do not edit.
local function starts_with(text, prefix)
  return (string.sub(text, 0, #prefix) == prefix)
end
local function ends_with(str, suffix)
  return ((suffix == "") or (suffix == string.sub(str, ( - #suffix))))
end
return {["starts-with"] = starts_with, ["ends-with"] = ends_with}
