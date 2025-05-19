(import-macros {: tx} :own.macros)
(local {: border} (require :own.config))

(set vim.g.conjure#log#hud#border border)
(set vim.g.conjure#client#fennel#aniseed#deprecation_warning false)
(set vim.g.conjure#filetypes [:fennel :clojure])

(tx :Olical/conjure {:branch :main})
