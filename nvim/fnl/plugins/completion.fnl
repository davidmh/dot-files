(import-macros {: map : tx} :own.macros)
(local {: autoload} (require :nfnl.module))
(local cmp (autoload :cmp))
(local ls (autoload :luasnip))
(local lspkind (autoload :lspkind))

(set vim.opt.completeopt [:menuone :menuone :noselect :popup :fuzzy])

(fn cmp-format [entry vim-item]
  (let [kind-fmt (lspkind.cmp_format {:mode :symbol
                                      :maxwidth 30})
        kind-item (kind-fmt entry vim-item)]
    (tset kind-item :kind (.. " " kind-item.kind " "))
    kind-item))

(fn config []
  (local cmd-mappings {:<C-d> (cmp.mapping.scroll_docs -4)
                       :<C-f> (cmp.mapping.scroll_docs 4)
                       :<C-Space> (cmp.mapping.complete)
                       :<C-e> (cmp.mapping.close)
                       :<C-y> (cmp.mapping.confirm {:behavior cmp.ConfirmBehavior.Insert
                                                    :select true})})

  (cmp.setup {:mapping (cmp.mapping.preset.insert cmd-mappings)
              :sources (cmp.config.sources [{:name :luasnip}
                                            {:name :nvim_lsp}
                                            {:name :emoji}
                                            {:name :nerdfonts}
                                            {:name :conjure}
                                            {:name :buffer :keyword_length 5}
                                            {:name :obsidian}
                                            {:name :obsidian_new}
                                            {:name :obsidian_tags}])
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

  (map [:i] :<c-h> #(if (ls.choice_active) (ls.change_choice -1)))
  (map [:i] :<c-l> #(if (ls.choice_active) (ls.change_choice 1)))

  ;; snippets config
  (local js-log (ls.parser.parse_snippet :debug "console.log('DEBUG', { $0 });"))
  (local co-authored-by (ls.parser.parse_snippet :cab "Co-authored-by: $0"))

  (ls.add_snippets :all [(ls.parser.parse_snippet :todo "TODO: $0")
                         (ls.snippet :date (ls.function_node #(os.date "%Y-%m-%d")))])
  (ls.add_snippets :javascript [js-log])
  (ls.add_snippets :typescript [js-log])
  (ls.add_snippets :typescriptreact [js-log])
  (ls.add_snippets :gitcommit [co-authored-by])
  (ls.add_snippets :org [(ls.parser.parse_snippet "<s" "#+BEGIN_SRC ${1}\n${0}\n#+END_SRC\n")]))

[(tx :hrsh7th/nvim-cmp {:dependencies [:hrsh7th/cmp-nvim-lsp
                                       :hrsh7th/cmp-buffer
                                       :PaterJason/cmp-conjure
                                       :saadparwaiz1/cmp_luasnip
                                       :L3MON4D3/LuaSnip
                                       :davidmh/cmp-nerdfonts
                                       :onsails/lspkind-nvim
                                       :hrsh7th/cmp-emoji]
                        :event :InsertEnter
                        : config})]
