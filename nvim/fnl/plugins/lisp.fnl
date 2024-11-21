(import-macros {: use} :own.macros)

[(use :Olical/nfnl {:ft :fennel})

 (use :clojure-vim/vim-jack-in {:ft [:clojure]})

 (use :gpanders/nvim-parinfer {:ft [:clojure :fennel :query]
                               :config #(set vim.g.parinfer_filetypes [:clojure
                                                                       :scheme
                                                                       :lisp
                                                                       :fennel
                                                                       :query])})]
