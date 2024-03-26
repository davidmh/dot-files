-- [nfnl] Compiled from fnl/plugins/copilot.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local str = autoload("own.string")
local function _2_()
  local path = vim.api.nvim_buf_get_name(0)
  return ((nil == string.match(path, ".*env.*")) and not str["ends-with"](path, ".zprofile"))
end
return {"zbirenbaum/copilot.lua", event = "InsertEnter", opts = {suggestion = {enabled = true, auto_trigger = true, keymap = {next = "<m-n>", prev = "<m-p>", accept = "<m-y>", accept_word = "<m-w>", accept_line = "<m-l>", dismiss = "<m-[>"}}, panel = {enabled = true}, filetypes = {clojure = true, css = true, gitcommit = true, go = true, javascript = true, typescript = true, typescriptreact = true, toggleterm = true, fennel = true, less = true, lua = true, nix = true, python = true, ruby = true, rust = true, zsh = _2_, norg = true, sh = true, sql = true, ["*"] = false}}}
