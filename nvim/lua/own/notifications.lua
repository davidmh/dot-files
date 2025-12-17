-- [nfnl] fnl/own/notifications.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_.autoload
local define = _local_1_.define
local M = define("own.notifications")
local snacks = autoload("snacks")
local function confirm(picker, choice)
  picker:close()
  if choice then
    local text = ("\n**" .. (choice.item.icon or "\243\176\141\161 ") .. (((choice.item.title == "") and "no title") or choice.item.title) .. "**\n\n" .. choice.item.msg)
    return snacks.win({width = 0.5, height = 0.4, border = "solid", wo = {wrap = true, conceallevel = 3, signcolumn = "no", statuscolumn = " ", spell = false}, bo = {filetype = choice.preview.ft, buftype = "nofile", modifiable = false}, text = text, keys = {["<esc>"] = "close"}, backdrop = false})
  else
    return nil
  end
end
M.open = function()
  return snacks.picker.notifications({confirm = confirm})
end
M.discard = function()
  return snacks.notifier.hide()
end
return M
