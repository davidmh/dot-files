(import-macros {: autocmd} :own.macros)
(local {: set-quickfix-mappings} (require :own.quickfix))

(set vim.wo.number true)
(set-quickfix-mappings)
