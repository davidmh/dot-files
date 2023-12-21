(import-macros {: use} :own.macros)
(local {: border} (require :own.config))

[:Olical/nfnl ; Fennel

 :clojure-vim/vim-jack-in ; Clojure

 (use :gpanders/nvim-parinfer {:ft [:clojure :fennel :query]})

 (use :Olical/conjure ; repl, but better
      {:config #(do
                  (set vim.g.conjure#log#hud#border border)
                  (set vim.g.conjure#filetype#sql nil)
                  (set vim.g.conjure#filetype#python nil))})]
