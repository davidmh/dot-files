-- [nfnl] Compiled from fnl/plugins/oil.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("own.config")
local border = _local_1_["border"]
return {"stevearc/oil.nvim", dependencies = {"nvim-tree/nvim-web-devicons"}, keys = {{"<leader>fs", "<c-w>s<cmd>Oil<cr>", desc = "file explorer in split"}, {"<leader>fv", "<c-w>v<cmd>Oil<cr>", desc = "file explorer in vertical split"}, {"<leader>f.", "<cmd>Oil<cr>", desc = "file explorer in current window"}}, opts = {keymaps = {["<c-v>"] = {"actions.select", opts = {vertical = true}}, ["<c-s>"] = {"actions.select", opts = {horizontal = true}}, ["<c-h>"] = false, ["<c-l>"] = false}, view_options = {show_hidden = true}, confirmation = {border = border}, progress = {border = border}, keymaps_help = {border = border}}}
