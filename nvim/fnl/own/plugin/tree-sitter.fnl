(module own.plugin.tree-sitter
  {autoload {ts-parsers nvim-treesitter.parsers
             config nvim-treesitter.configs}})

(def- additional-vim-regex-highlighting [])
(def- ensure-installed [:bash
                        :fennel
                        :gitattributes
                        :gitcommit
                        :git_config
                        :git_rebase
                        ; :hcl
                        :html
                        :json
                        :json5
                        :lua
                        :luadoc
                        :make
                        :markdown
                        :markdown_inline
                        :nix
                        :python
                        :query
                        :regex
                        :ruby
                        :rust
                        :sql
                        :terraform
                        :tsx
                        :typescript
                        :vim
                        :vimdoc
                        :yaml])

(when-let [(ok? org-mode) (pcall require :orgmode)]
  (org-mode.setup_ts_grammar)
  (table.insert ensure-installed :org)
  (table.insert additional-vim-regex-highlighting :org))

(def- ts-configs (ts-parsers.get_parser_configs))
; (tset ts-configs :hcl {:install_info {:url :https://github.com/MichaHoffmann/tree-sitter-hcl
;                                       :files [:src/parser.c :src/scanner.cc]
;                                       :branch :main}})

(config.setup {:highlight {:enable true}
               :indent {:enable true}
               :incremental_selection {:enable true
                                       :additional_vim_regex_highlighting additional-vim-regex-highlighting
                                       :keymaps {:init_selection :gnn
                                                 :node_incremental :<tab>
                                                 :node_decremental :<s-tab>
                                                 :scope_incremental :<leader><tab>}}
               :textobjects {:enable true}
               :ensure_installed ensure-installed
               :table_of_contents {:enable true}})
