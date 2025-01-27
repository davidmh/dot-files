-- [nfnl] Compiled from fnl/plugins/codeium.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local parpar = autoload("parpar")
local codeium_virtual_text = autoload("codeium.virtual_text")
local function codeium_2faccept()
  vim.schedule(parpar.pause())
  return codeium_virtual_text.accept()
end
local function _2_()
  return vim.keymap.set("i", "<M-y>", codeium_2faccept, {expr = true, silent = true})
end
return {"Exafunction/codeium.nvim", event = "InsertEnter", dependencies = {"nvim-lua/plenary.nvim"}, init = _2_, opts = {virtual_text = {enabled = true, filetypes = {TelescopePrompt = false, zsh = false}, default_filetype_enabled = true, key_bindings = {clear = "<M-c>", next = "<M-n>", prev = "<M-p>", accept = false}}, enable_cmp_source = false}}
