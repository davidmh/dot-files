-- [nfnl] Compiled from fnl/own/plugin/which-key.fnl by https://github.com/Olical/nfnl, do not edit.
local which_key = require("which-key")
which_key.setup({})
return which_key.register({mode = {"n"}, ["<leader>g"] = {name = "git"}, ["<leader>l"] = {name = "lsp"}, ["<leader>o"] = {name = "org"}, ["<leader>b"] = {name = "buffer"}, ["<leader>t"] = {name = "toggle"}, ["<leader>v"] = {name = "vim"}, ["<leader>/"] = {name = "find"}})
