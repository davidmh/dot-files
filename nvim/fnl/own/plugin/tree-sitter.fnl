(module own.plugin.tree-sitter
  {autoload {ts-parsers nvim-treesitter.parsers
             config nvim-treesitter.configs}})

(def- ts-configs (ts-parsers.get_parser_configs))
(tset ts-configs :hcl {:install_info {:url :https://github.com/MichaHoffmann/tree-sitter-hcl
                                      :files [:src/parser.c :src/scanner.cc]
                                      :branch :main}})

(config.setup {:highlight {:enable true}
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
                                  :yaml]})
