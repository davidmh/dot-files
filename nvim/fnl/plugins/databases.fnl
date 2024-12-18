(import-macros {: use} :own.macros)

(fn config []
  (set vim.g.dbs {:remix_development "postgres:remix_development"}))

(use :tpope/vim-dadbod  {:dependencies [:kristijanhusak/vim-dadbod-ui]
                         :cmd [:DB :DBUIToggle]
                         :config config})
