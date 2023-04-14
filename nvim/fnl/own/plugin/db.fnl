(module own.plugin.db
  {autoload {cmp cmp
             nvim aniseed.nvim}})

(set nvim.g.dbs {:remix_development "postgres:remix_development"})

(defn- dadbod-setup []
  (set vim.bo.omnifunc :vim_dadbod_completion#omni)
  (cmp.setup.buffer {:sources [{:name :vim-dadbod-completion}]}))

(nvim.create_autocmd :FileType {:pattern :sql
                                :callback dadbod-setup})
