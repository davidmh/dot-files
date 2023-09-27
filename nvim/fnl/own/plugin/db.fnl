(local cmp (require :cmp))

(set vim.g.dbs {:remix_development "postgres:remix_development"})

(fn dadbod-setup []
  (set vim.bo.omnifunc :vim_dadbod_completion#omni)
  (cmp.setup.buffer {:sources [{:name :vim-dadbod-completion}]}))

(vim.api.nvim_create_autocmd :FileType {:pattern :sql
                                        :callback dadbod-setup})
