(import-macros {: use} :own.macros)
(local {: border} (require :own.config))

[(use :Olical/nfnl {:ft :fennel})

 (use :clojure-vim/vim-jack-in {:ft [:clojure]})

 (use :gpanders/nvim-parinfer {:ft [:clojure :fennel :query]})

 (use :Olical/conjure ; repl, but better
      {:config #(do
                  (set vim.g.conjure#log#hud#border border)
                  (set vim.g.conjure#filetype#sql nil)
                  (set vim.g.conjure#filetype#python nil))})]
