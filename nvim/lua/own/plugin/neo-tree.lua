-- [nfnl] Compiled from fnl/own/plugin/neo-tree.fnl by https://github.com/Olical/nfnl, do not edit.
local core = require("nfnl.core")
local neo_tree = require("neo-tree")
local commands = require("neo-tree.sources.common.commands")
local function git_2fstage_unstage(state)
  local path = core.get((state.tree):get_node(), "path")
  local status = core.get(state.git_status_lookup, path)
  if (string.match(status, "?") or (status == " M")) then
    commands.git_add_file(state)
    return
  else
  end
  if (string.match(status, "A") or string.match(status, "M")) then
    commands.git_unstage_file(state)
    return
  else
  end
  return vim.notify(("unhandled status: " .. status), vim.log.levels.DEBUG, {icon = "\239\135\146", title = "custom neo-tree commands"})
end
return neo_tree.setup({window = {mappings = {["-"] = {git_2fstage_unstage, desc = "stage/unstage"}, X = {"git_revert_file", desc = "revert"}}}, hide_hidden = false})
