(import-macros {: use} :own.macros)
(local {: autoload} (require :nfnl.module))
(local cmp (autoload :cmp))

(fn dadbod-setup []
  (set vim.bo.omnifunc :vim_dadbod_completion#omni)
  (cmp.setup.buffer {:sources [{:name :vim-dadbod-completion}]}))

(fn config []
  (set vim.g.dbs {:remix_development "postgres:remix_development"})

  (vim.api.nvim_create_autocmd :FileType {:pattern :sql
                                          :callback dadbod-setup}))

(use :tpope/vim-dadbod  {:dependencies [:kristijanhusak/vim-dadbod-completion
                                        :kristijanhusak/vim-dadbod-ui
                                        :hrsh7th/nvim-cmp]
                         :cmd [:DB :DBUIToggle]
                         :config config})
