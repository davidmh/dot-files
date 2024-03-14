-- [nfnl] Compiled from fnl/plugins/starter.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local _local_2_ = require("nfnl.core")
local get = _local_2_["get"]
local first = _local_2_["first"]
local _local_3_ = require("own.helpers")
local sanitize_path = _local_3_["sanitize-path"]
local mini_starter = autoload("mini.starter")
local projects = autoload("own.projects")
math.randomseed(os.time())
local quotes = {"vim is only free if your time has no value.", "Eat right, stay fit, and die anyway.", "Causes moderate eye irritation.", "May cause headaches.", "And now for something completely different.", "What are we breaking today?", "Oh good, it's almost bedtime."}
local function format_recent(_4_)
  local _arg_5_ = _4_
  local name = _arg_5_["name"]
  local action = _arg_5_["action"]
  local section = _arg_5_["section"]
  local path = string.gsub(action, "edit ", "")
  return {name = (first(vim.split(name, " ")) .. " -> " .. sanitize_path(path, 3)), action = action, section = section}
end
local function recent_entries()
  return vim.tbl_map(format_recent, mini_starter.sections.recent_files(15, false, true)())
end
local function config()
  return mini_starter.setup({header = get(quotes, math.random(#quotes)), items = {recent_entries(), projects["recent-projects"](10)}, footer = ""})
end
local function open_starter()
  config()
  return mini_starter.open()
end
return {"echasnovski/mini.starter", version = "*", event = "VimEnter", config = config, keys = {{"<localleader>s", open_starter, desc = "Open Starter"}}}
