-- [nfnl] Compiled from fnl/plugins/neo-tree.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.core")
local get = _local_1_["get"]
local _local_2_ = require("nfnl.module")
local autoload = _local_2_["autoload"]
local commands = autoload("neo-tree.sources.common.commands")
local function git_2fstage_unstage(state)
  local path = get((state.tree):get_node(), "path")
  local status = get(state.git_status_lookup, path)
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
return {{"s1n7ax/nvim-window-picker", event = "VeryLazy", config = true}, {"nvim-neo-tree/neo-tree.nvim", branch = "v3.x", dependencies = {"nvim-lua/plenary.nvim", "kyazdani42/nvim-web-devicons", "MunifTanjim/nui.nvim", "s1n7ax/nvim-window-picker"}, opts = {window = {mappings = {["-"] = {git_2fstage_unstage, desc = "stage/unstage"}, X = {"git_revert_file", desc = "revert"}}}, hide_hidden = false}}}
