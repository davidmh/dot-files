(module own.plugin.completion
  {autoload {nvim aniseed.nvim
             core aniseed.core
             cmp cmp
             cmp-git cmp_git
             cmp-copilot copilot_cmp
             ls luasnip
             ls-types luasnip.util.types
             lspkind lspkind}})

(set nvim.o.completeopt "menuone,noselect,preview")

(cmp-git.setup)
(cmp-copilot.setup)

(def- menu-sources {:path      "(path)"
                    :luasnip   "(snip)"
                    :nvim_lsp  "(lsp)"
                    :emoji     "(emo)"
                    :conjure   "(conj)"
                    :copilot   "(copilot)"
                    :orgmode   "(org)"
                    :nerdfonts "(font)"
                    :buffer    "(buff)"
                    :nvim_lua  "(lua)"
                    :git       "(git)"
                    :omni      "(omni)"})

;; use v2 nerdfonts
(def- v2-symbol-map {:Text :
                     :Method :
                     :Function :
                     :Constructor :
                     :Field :
                     :Variable :
                     :Class :
                     :Interface :
                     :Module :
                     :Property :
                     :Unit :
                     :Value :
                     :Enum :
                     :Keyword :
                     :Snippet :
                     :Color :
                     :File :
                     :Reference :
                     :Folder :
                     :EnumMember :
                     :Constant :
                     :Struct :
                     :Event :
                     :Operator :
                     :TypeParameter :
                     :Copilot :})

(defn- cmp-format [entry vim-item]
  (let [kind-fmt (lspkind.cmp_format {:mode :symbol
                                      :menu menu-sources
                                      :maxwidth 30
                                      :symbol_map v2-symbol-map})
        kind-item (kind-fmt entry vim-item)]
    (tset kind-item :kind (.. " " kind-item.kind " "))
    kind-item))

(def- cmd-mappings {:<C-d> (cmp.mapping.scroll_docs -4)
                    :<C-f> (cmp.mapping.scroll_docs 4)
                    :<C-Space> (cmp.mapping.complete)
                    :<C-e> (cmp.mapping.close)
                    :<C-y> (cmp.mapping.confirm {:behavior cmp.ConfirmBehavior.Insert
                                                 :select true})})

(cmp.setup {:mapping (cmp.mapping.preset.insert cmd-mappings)
            :sources (cmp.config.sources [{:name :copilot}
                                          {:name :luasnip}
                                          {:name :nvim_lsp}
                                          {:name :orgmode}
                                          {:name :emoji}
                                          {:name :git}
                                          {:name :nerdfonts}
                                          {:name :conjure}
                                          {:name :buffer :keyword_length 5}])
            :formatting {:fields [:kind :abbr :menu]
                         :format cmp-format}
            :snippet {:expand (fn [args] (ls.lsp_expand args.body))}
            :window {:completion {:winhighlight "Normal:Pmenu,FloatBorder:Pmenu,Search:None"
                                  :col_offset -3
                                  :side_padding 0}}})

(cmp.setup.cmdline {:mapping (cmp.mapping.preset.cmdline cmd-mappings)})

(ls.config.setup {:history true
                  :update_events "TextChanged,TextChangedI"
                  :enable_autosnippets true})

(vim.keymap.set [:i :s]
                :<c-k>
                (fn [] (if (ls.expand_or_jumpable) (ls.expand_or_jump)))
                {:silent true})

(vim.keymap.set [:i]
                :<c-l>
                (fn [] (if (ls.choice_active) (ls.change_choice 1))))

;; snippets config
(def- js-log (ls.snippet :debug [(ls.text_node "console.log('DEBUG', { ")
                                 (ls.insert_node 0)
                                 (ls.text_node " });")]))

(def- js-test-case (ls.snippet :it [(ls.text_node "it('")
                                    (ls.insert_node 1)
                                    (ls.text_node "', () => {")
                                    (ls.insert_node 0)
                                    (ls.text_node "});")]))

(ls.add_snippets :all [(ls.snippet :todo [(ls.text_node "TODO(dmejorado): ")
                                          (ls.insert_node 0)])
                       (ls.snippet :today (ls.function_node (fn [] (os.date "%Y-%m-%d"))))])
(ls.add_snippets :javascript [js-log js-test-case])
(ls.add_snippets :typescript [js-log js-test-case])
(ls.add_snippets :typescriptreact [js-log js-test-case])
(ls.add_snippets :gitcommit [(ls.parser.parse_snippet "cab" "Co-Authored-By: $0")])
(ls.add_snippets :org [(ls.parser.parse_snippet "<s" "#+BEGIN_SRC ${1}\n${0}\n#+END_SRC\n")])
