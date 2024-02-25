-- [nfnl] Compiled from fnl/plugins/which-key.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local which_key = autoload("which-key")
local function _2_()
  return which_key.register({mode = {"n"}, ["<leader>a"] = {name = "alternate"}, ["<leader>g"] = {name = "git", h = {name = "hunk"}}, ["<leader>l"] = {name = "lsp"}, ["<leader>o"] = {name = "org"}, ["<leader>b"] = {name = "buffer"}, ["<leader>t"] = {name = "toggle"}, ["<leader>v"] = {name = "vim"}, ["<leader>f"] = {name = "file-tree"}, ["<leader>/"] = {name = "find"}, ["<localleader>g"] = {name = "gemini"}, ["<localleader>t"] = {name = "test"}})
end
return {"folke/which-key.nvim", dependencies = {"nvim-lua/plenary.nvim"}, event = "VeryLazy", config = _2_}
