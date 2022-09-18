(module own.plugin.tree-sitter
  {autoload {orgmode orgmode
             ts-parsers nvim-treesitter.parsers
             config nvim-treesitter.configs}})

(def- ts-configs (ts-parsers.get_parser_configs))
(tset ts-configs :hcl {:install_info {:url :https://github.com/MichaHoffmann/tree-sitter-hcl
                                      :files [:src/parser.c :src/scanner.cc]
                                      :branch :main}})

(orgmode.setup_ts_grammar)

(config.setup {:highlight {:enable true
                           :additional_vim_regex_highlighting [:org]}
               :indent {:enable true}
               :incremental_selection {:enable true
                                       :keymaps {:init_selection :gnn
                                                 :node_incremental :<tab>
                                                 :node_decremental :<s-tab>
                                                 :scope_incremental :<leader><tab>}}
               :textobjects {:enable true}
               :ensure_installed [:bash
                                  :fennel
                                  :hcl
                                  :html
                                  :json
                                  :lua
                                  :org
                                  :python
                                  :query
                                  :ruby
                                  :rust
                                  :sql
                                  :tsx
                                  :typescript
                                  :nix
                                  :yaml]})
