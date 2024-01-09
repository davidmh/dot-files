(import-macros {: map : use} :own.macros)
(local {: autoload} (require :nfnl.module))
(local cmp (autoload :cmp))
(local ls (autoload :luasnip))
(local lspkind (autoload :lspkind))
(local from-vscode (autoload :luasnip.loaders.from_vscode))

(set vim.o.completeopt "menuone,noselect,preview")

(local menu-sources {:path      "(path)"
                     :luasnip   "(snip)"
                     :nvim_lsp  "(lsp)"
                     :emoji     "(emo)"
                     :conjure   "(conj)"
                     :orgmode   "(org)"
                     :nerdfonts "(font)"
                     :buffer    "(buff)"
                     :nvim_lua  "(lua)"
                     :git       "(git)"
                     :omni      "(omni)"})

;; use v2 nerdfonts
(local v2-symbol-map {:Text :
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

(fn cmp-format [entry vim-item]
  (let [kind-fmt (lspkind.cmp_format {:mode :symbol
                                      :menu menu-sources
                                      :maxwidth 30
                                      :symbol_map v2-symbol-map})
        kind-item (kind-fmt entry vim-item)]
    (tset kind-item :kind (.. " " kind-item.kind " "))
    kind-item))

(fn config []
  (from-vscode.lazy_load)
  (local cmd-mappings {:<C-d> (cmp.mapping.scroll_docs -4)
                       :<C-f> (cmp.mapping.scroll_docs 4)
                       :<C-Space> (cmp.mapping.complete)
                       :<C-e> (cmp.mapping.close)
                       :<C-y> (cmp.mapping.confirm {:behavior cmp.ConfirmBehavior.Insert
                                                    :select true})})

  (cmp.setup {:mapping (cmp.mapping.preset.insert cmd-mappings)
              :sources (cmp.config.sources [{:name :luasnip}
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

  (map [:i :s] :<c-k> #(if (ls.expand_or_jumpable) (ls.expand_or_jump)))

  (map [:i] :<c-l> #(if (ls.choice_active) (ls.change_choice 1)))

  ;; snippets config
  (local js-log (ls.snippet :debug [(ls.text_node "console.log('DEBUG', { ")
                                    (ls.insert_node 0)
                                    (ls.text_node " });")]))

  (local js-test-case (ls.snippet :it [(ls.text_node "it('")
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
  (ls.add_snippets :org [(ls.parser.parse_snippet "<s" "#+BEGIN_SRC ${1}\n${0}\n#+END_SRC\n")]))

[(use :petertriho/cmp-git {:dependencies [:nvim-lua/plenary.nvim]
                           :config true
                           :event :InsertEnter})
 (use :hrsh7th/nvim-cmp {:dependencies [:hrsh7th/cmp-nvim-lsp
                                        :hrsh7th/cmp-buffer
                                        :PaterJason/cmp-conjure
                                        :saadparwaiz1/cmp_luasnip
                                        :L3MON4D3/LuaSnip
                                        :davidmh/cmp-nerdfonts
                                        :onsails/lspkind-nvim
                                        :petertriho/cmp-git
                                        :hrsh7th/cmp-emoji
                                        :rafamadriz/friendly-snippets]
                         :event :InsertEnter
                         : config})]
