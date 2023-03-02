(module own.plugin.completion
  {autoload {nvim aniseed.nvim
             core aniseed.core
             cmp cmp
             lspkind lspkind}})

(set nvim.o.completeopt "menuone,noselect,preview")

(def- menu-sources {:path      "[path]"
                    :nvim_lsp  "[lsp]"
                    :conjure   "[conjure]"
                    :emoji     "[emoji]"
                    :nerdfonts "[nerd fonts]"
                    :buffer    "[buffer]"
                    :nvim_lua  "[lua]"
                    :omni      "[omni]"})

(def- cmd-mappings {:<C-d> (cmp.mapping.scroll_docs -4)
                    :<C-f> (cmp.mapping.scroll_docs 4)
                    :<C-Space> (cmp.mapping.complete)
                    :<C-e> (cmp.mapping.close)
                    :<C-y> (cmp.mapping.confirm {:behavior cmp.ConfirmBehavior.Insert
                                                 :select true})})

(cmp.setup {:mapping (cmp.mapping.preset.insert cmd-mappings)
            :sources (cmp.config.sources [{:name :nvim_lsp}
                                          {:name :emoji :insert true}
                                          {:name :nerdfonts}
                                          {:name :conjure}
                                          {:name :buffer :keyword_length 5}])})

(cmp.setup.cmdline {:mapping (cmp.mapping.preset.cmdline cmd-mappings)})
(cmp.setup.filetype :gitcommit {:sources (cmp.config.sources [{:name :emoji
                                                               :insert true}])})
