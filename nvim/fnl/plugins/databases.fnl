(import-macros {: tx} :own.macros)

(fn config []
  (set vim.g.dbs {:remix_development "postgres:remix_development"}))

(tx :tpope/vim-dadbod  {:dependencies [:kristijanhusak/vim-dadbod-ui]
                        :cmd [:DB :DBUIToggle]
                        :config config})
