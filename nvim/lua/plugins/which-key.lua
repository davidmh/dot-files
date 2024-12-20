-- [nfnl] Compiled from fnl/plugins/which-key.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local which_key = autoload("which-key")
local function _2_()
  return which_key.add({{"<leader>g", group = "git"}, {"<leader>gh", group = "hunk"}, {"<leader>l", group = "lsp"}, {"<leader>o", group = "Obsidian"}, {"<leader>b", group = "buffer"}, {"<leader>t", group = "toggle"}, {"<leader>v", group = "vim"}, {"<leader>/", group = "find"}})
end
return {"folke/which-key.nvim", dependencies = {"nvim-lua/plenary.nvim"}, event = "VeryLazy", config = _2_}
