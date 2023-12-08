-- [nfnl] Compiled from fnl/own/plugin/neorg.fnl by https://github.com/Olical/nfnl, do not edit.
local neorg = require("neorg")
local options = {load = {["core.defaults"] = {}, ["core.concealer"] = {}, ["core.completion"] = {config = {engine = "nvim-cmp"}}, ["core.integrations.treesitter"] = {config = {configure_parsers = true, install_parsers = true}}, ["core.export"] = {config = {export_dir = "/tmp/"}}, ["core.export.markdown"] = {config = {extension = ".md"}}, ["core.dirman"] = {config = {workspaces = {notes = "~/Documents/neorg"}}}, ["core.mode"] = {}}}
if (vim.re ~= nil) then
  options.load["core.ui.calendar"] = {}
else
  options.load["core.ui.calendar.views.monthly"] = {}
  if nil then
    options.load["core.tempus"] = {}
  else
  end
end
return neorg.setup(options)
