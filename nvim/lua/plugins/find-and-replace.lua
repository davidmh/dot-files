-- [nfnl] Compiled from fnl/plugins/find-and-replace.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local grug_far = autoload("grug-far")
local function open_result_and_close_search()
  return vim.keymap.set("n", "<C-enter>", "<localleader>o<localleader>c", {buffer = true, remap = true})
end
do
  local group = vim.api.nvim_create_augroup("grug-far-keybindings", {clear = true})
  vim.api.nvim_create_autocmd("FileType", {pattern = "grug-far", callback = open_result_and_close_search, group = group})
end
return {"MagicDuck/grug-far.nvim", opts = {}, cmd = {"GrugFar"}}
