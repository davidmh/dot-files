(module own.plugin.db
  {autoload {cmp cmp
             wk which-key
             nvim aniseed.nvim}})

(set nvim.g.dbs {:remix_development "postgres://postgres@localhost:5432/remix_development"})

(defn- dadbod-setup []
  (set vim.bo.omnifunc :vim_dadbod_completion#omni)
  (cmp.setup.buffer {:sources [{:name :vim-dadbod-completion}]}))

(nvim.create_autocmd :FileType {:pattern :sql
                                :callback dadbod-setup})

(wk.register {:d [:<cmd>DBUIToggle<cr> :toggle]} {:prefix :<localleader>})
