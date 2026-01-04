-- [nfnl] fnl/plugins/find-and-replace.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_.autoload
local grug_far = autoload("grug-far")
local function open_quickfix_and_close_grug()
  local instance = grug_far.get_instance(0)
  instance:open_quickfix()
  instance:close()
  return vim.cmd.cfirst()
end
do
  local group = vim.api.nvim_create_augroup("grug-far-keybindings", {clear = true})
  local function _2_()
    return vim.keymap.set("n", "<C-enter>", open_quickfix_and_close_grug, {buffer = true})
  end
  vim.api.nvim_create_autocmd("FileType", {pattern = "grug-far", callback = _2_, group = group})
end
return {"MagicDuck/grug-far.nvim", opts = {}, cmd = {"GrugFar"}, keys = {{"<localleader>g", "<cmd>GrugFar<cr>", desc = "grug-far", mode = "n"}}}
