-- [nfnl] fnl/plugins/gitattributes.fnl
local _local_1_ = require("nfnl.core")
local assoc_in = _local_1_["assoc-in"]
local function on_match(params)
  local attributes = params["attributes"]
  local buffer = params["buffer"]
  if attributes["linguist-generated"] then
    assoc_in(vim.bo, {buffer, "readonly"}, true)
    assoc_in(vim.bo, {buffer, "modifiable"}, false)
  else
  end
  if attributes["linguist-language"] then
    assoc_in(vim.bo, {buffer, "filetype"}, attributes["linguist-language"])
  else
  end
  return vim.notify(vim.inspect(params), vim.log.levels.DEBUG, {title = "Gitattributes", icon = "\243\176\138\162"})
end
return {"davidmh/gitattributes.nvim", opts = {on_match = on_match}}
