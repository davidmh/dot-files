(import-macros {: tx} :own.macros)

(tx :dundalek/parpar.nvim {:dependencies [:gpanders/nvim-parinfer
                                          :julienvincent/nvim-paredit]
                           :opts {:use_default_keys true}
                           :ft [:clojure :fennel :query :lisp]})
