-- [nfnl] fnl/plugins/snacks.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local _local_2_ = require("nfnl.core")
local assoc_in = _local_2_["assoc-in"]
local get = _local_2_["get"]
local _local_3_ = require("own.projects")
local find_files = _local_3_["find-files"]
local project_list = _local_3_["project-list"]
local actions = autoload("snacks.picker.actions")
math.randomseed(os.time())
local quotes = {"vim is only free if your time has no value.", "Eat right, stay fit, and die anyway.", "Causes moderate eye irritation.", "May cause headaches.", "And now for something completely different.", "What are we breaking today?", "Oh good, it's almost bedtime."}
local function _4_(picker, item)
  if (item and item.command and (item.command.nargs == "0")) then
    picker:close()
    local function _5_()
      return vim.cmd(item.cmd)
    end
    return vim.schedule(_5_)
  else
    return actions.cmd(picker, item)
  end
end
local function _7_()
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
return {"folke/snacks.nvim", priority = 1000, opts = {bigfile = {enabled = true}, statuscolumn = {enabled = true}, dashboard = {enabled = true, preset = {header = get(quotes, math.random(#quotes))}, sections = {{section = "header"}, {icon = "\239\131\133", title = "Recent files", section = "recent_files", indent = 2, padding = 1, limit = 10}, {icon = "\238\171\183", title = "Projects", section = "projects", indent = 2, action = find_files, dirs = project_list, limit = 10, padding = 1}, {section = "startup"}}}, input = {enabled = true, win = {relative = "cursor", col = 0, row = 1}}, image = {force = true, doc = {inline = true}}, notifier = {enabled = true, style = "fancy", margin = {bottom = 2}, top_down = false}, picker = {sources = {commands = {confirm = "cmd!"}, files = {win = {input = {keys = {["<c-x>"] = {"edit_split", mode = {"i", "n"}}}}}, hidden = true}}, actions = {["cmd!"] = _4_}}, terminal = {win = {position = "bottom", bo = {filetype = "terminal"}, wo = {winbar = "", winhighlight = "Normal:Normal"}}}}, init = _7_, lazy = false}
