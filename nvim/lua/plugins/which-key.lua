-- [nfnl] Compiled from fnl/plugins/which-key.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local which_key = autoload("which-key")
local function _2_()
  return which_key.add({{"<leader>a", group = "alternate"}, {"<leader>g", group = "git"}, {"<leader>gh", group = "hunk"}, {"<leader>l", group = "lsp"}, {"<leader>o", group = "org"}, {"<leader>b", group = "buffer"}, {"<leader>t", group = "toggle"}, {"<leader>v", group = "vim"}, {"<leader>f", group = "file-tree"}, {"<leader>/", group = "find"}, {"<localleader>g", group = "gemini"}, {"<localleader>t", group = "test"}})
end
return {"folke/which-key.nvim", dependencies = {"nvim-lua/plenary.nvim"}, event = "VeryLazy", config = _2_}
