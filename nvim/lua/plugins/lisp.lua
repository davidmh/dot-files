-- [nfnl] Compiled from fnl/plugins/lisp.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("own.config")
local border = _local_1_["border"]
local function _2_()
  vim.g["conjure#log#hud#border"] = border
  vim.g["conjure#filetype#sql"] = nil
  vim.g["conjure#filetype#rust"] = nil
  vim.g["conjure#filetype#python"] = nil
  return nil
end
return {{"Olical/nfnl", ft = "fennel"}, {"clojure-vim/vim-jack-in", ft = {"clojure"}}, {"gpanders/nvim-parinfer", ft = {"clojure", "fennel", "query"}}, {"Olical/conjure", config = _2_}}
