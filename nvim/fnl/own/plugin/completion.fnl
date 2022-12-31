(module own.plugin.completion
  {autoload {nvim aniseed.nvim
             core aniseed.core
             cmp cmp
             ls luasnip
             ls-types luasnip.util.types
             ls-from-vscode luasnip.loaders.from_vscode
             lspkind lspkind}})

(set nvim.o.completeopt "menuone,noselect,preview")

(def- menu-sources {:path      "[path]"
                    :luasnip   "[snippet]"
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
            :sources (cmp.config.sources [{:name :luasnip}
                                          {:name :nvim_lsp}
                                          {:name :emoji :insert true}
                                          {:name :nerdfonts}
                                          {:name :conjure}
                                          {:name :buffer :keyword_length 5}])
            :formatting {:format (lspkind.cmp_format {:with_text false
                                                      :menu menu-sources})}
            :snippet {:expand (fn [args] (ls.lsp_expand args.body))}})

(cmp.setup.cmdline {:mapping (cmp.mapping.preset.cmdline cmd-mappings)})
(cmp.setup.filetype :gitcommit {:sources (cmp.config.sources [{:name :emoji
                                                               :insert true}])})

(ls.config.setup {:history true
                  :update_events "TextChanged,TextChangedI"
                  :enable_autosnippets true
                  :ext_opts {ls-types.choiceNode {:active {:virt_text ["<-" "Error"]}}}})

(vim.keymap.set [:i :s]
                :<c-k>
                (fn [] (if (ls.expand_or_jumpable) (ls.expand_or_jump)))
                {:silent true})

(vim.keymap.set [:i]
                :<c-l>
                (fn [] (if (ls.choice_active) (ls.change_choice 1))))

;; snippets config

(ls-from-vscode.load)

(def- js-log (ls.snippet :debug [(ls.text_node "console.log('DEBUG', { ")
                                 (ls.insert_node 0)
                                 (ls.text_node " });")]))

(ls.add_snippets :all [(ls.snippet :todo [(ls.text_node "TODO(dmejorado): ")
                                          (ls.insert_node 0)])
                       (ls.snippet :today (ls.function_node (fn [] (os.date "%Y-%m-%d"))))])
(ls.add_snippets :javascript [js-log])
(ls.add_snippets :typescript [js-log])
(ls.add_snippets :typescriptreact [js-log])
