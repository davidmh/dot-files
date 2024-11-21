-- [nfnl] Compiled from fnl/plugins/lisp.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  vim.g.parinfer_filetypes = {"clojure", "scheme", "lisp", "fennel", "query"}
  return nil
end
return {{"Olical/nfnl", ft = "fennel"}, {"clojure-vim/vim-jack-in", ft = {"clojure"}}, {"gpanders/nvim-parinfer", ft = {"clojure", "fennel", "query"}, config = _1_}}
