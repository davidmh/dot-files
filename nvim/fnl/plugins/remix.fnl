(import-macros {: autocmd : use} :own.macros)
(local {: autoload} (require :nfnl.module))
(local cmp (autoload :cmp))
(local remix-authors (autoload :remix.git-co-authors))
(local remix-utils (autoload :remix.utils))

(vim.api.nvim_create_augroup :remix-git-commit {:clear true})

(local source {:is_available #(remix-utils.is_remix_buffer)
               :get_debug_name #(-> :remix-authors)
               :get_trigger_characters #(-> ["Co-authored-by: "])
               :complete (fn [_ _ cb] (cb {:items (vim.tbl_map
                                                    #(-> {:label $1
                                                          :insertText $1
                                                          :filterText $1})
                                                    (remix-authors.get))}))})

(fn set-co-author-source []
  (when (remix-utils.is_remix_buffer)
    (cmp.register_source :remix-authors source)
    (cmp.setup.buffer {:sources (cmp.config.sources [{:name :remix-authors}
                                                     {:name :luasnip}
                                                     {:name :emoji}])})))

(fn config []
  (autocmd :FileType {:group :remix-git-commit
                      :pattern :gitcommit
                      :callback set-co-author-source}))

(use :remix.nvim {:dir :$REMIX_HOME/.nvim
                  :dependencies [:hrsh7th/nvim-cmp]
                  :name :remix
                  :opts {}
                  :config config})
