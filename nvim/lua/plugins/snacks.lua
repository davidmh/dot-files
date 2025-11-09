-- [nfnl] fnl/plugins/snacks.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_.autoload
local _local_2_ = require("nfnl.core")
local assoc_in = _local_2_["assoc-in"]
local actions = autoload("snacks.picker.actions")
local function _3_(picker, item)
  if (item and item.command and (item.command.nargs == "0")) then
    picker:close()
    local function _4_()
      return vim.cmd(item.cmd)
    end
    return vim.schedule(_4_)
  else
    return actions.cmd(picker, item)
  end
end
local function _6_()
  local snacks = require("snacks")
  vim.ui.select = snacks.picker.select
  local layouts = require("snacks.picker.config.layouts")
  assoc_in(layouts, {"default", "layout", 1, "border"}, "solid")
  assoc_in(layouts, {"default", "layout", 1, 1, "border"}, "solid")
  assoc_in(layouts, {"default", "layout", 2, "border"}, "solid")
  assoc_in(layouts, {"default", "layout", "backdrop"}, false)
  assoc_in(layouts, {"select", "layout", "border"}, "solid")
  return assoc_in(layouts, {"select", "layout", 1, "border"}, "none")
end
return {"folke/snacks.nvim", priority = 1000, opts = {bigfile = {enabled = true}, statuscolumn = {enabled = true}, input = {enabled = true, title_pos = "left", win = {relative = "cursor", col = 0, row = 1}}, image = {force = true, doc = {inline = true}}, notifier = {enabled = true, style = "fancy", margin = {bottom = 2}, top_down = false}, picker = {sources = {commands = {confirm = "cmd!"}, files = {win = {input = {keys = {["<c-x>"] = {"edit_split", mode = {"i", "n"}}}}}, hidden = true}}, actions = {["cmd!"] = _3_}}, terminal = {win = {position = "bottom", bo = {filetype = "terminal"}, wo = {winbar = "", winhighlight = "Normal:Normal"}}}}, init = _6_, lazy = false}
