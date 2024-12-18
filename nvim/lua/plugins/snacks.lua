-- [nfnl] Compiled from fnl/plugins/snacks.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("own.config")
local border = _local_1_["border"]
local _local_2_ = require("nfnl.core")
local get = _local_2_["get"]
local _local_3_ = require("own.projects")
local find_files = _local_3_["find-files"]
math.randomseed(os.time())
local quotes = {"vim is only free if your time has no value.", "Eat right, stay fit, and die anyway.", "Causes moderate eye irritation.", "May cause headaches.", "And now for something completely different.", "What are we breaking today?", "Oh good, it's almost bedtime."}
return {"folke/snacks.nvim", priority = 1000, opts = {bigfile = {enabled = true}, words = {enabled = true}, notifier = {enabled = true, margin = {bottom = 1, right = 0}, top_down = false}, dashboard = {enabled = true, preset = {header = get(quotes, math.random(#quotes))}, sections = {{section = "header"}, {icon = "\239\131\133", title = "Recent files", section = "recent_files", indent = 2, padding = 1}, {icon = "\238\171\183", title = "Projects", section = "projects", indent = 2, action = find_files, padding = 1}, {section = "startup"}}}, styles = {notification = {border = border}, notification_history = {border = border}}}, lazy = false}
