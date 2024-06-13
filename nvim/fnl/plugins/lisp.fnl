(import-macros {: use} :own.macros)
(local {: border} (require :own.config))

(set vim.g.conjure#log#hud#border border)
(set vim.g.conjure#filetypes [:fennel :clojure])
(set vim.g.conjure#filetype#sql nil)
(set vim.g.conjure#filetype#rust nil)
(set vim.g.conjure#filetype#python nil)
(set vim.g.conjure#filetype#lua nil)

[(use :Olical/nfnl {:ft :fennel})

 (use :clojure-vim/vim-jack-in {:ft [:clojure]})

 (use :gpanders/nvim-parinfer {:ft [:clojure :fennel :query]
                               :config #(set vim.g.parinfer_filetypes [:clojure
                                                                       :scheme
                                                                       :lisp
                                                                       :fennel
                                                                       :query])})

 (use :Olical/conjure)] ; repl, but better
