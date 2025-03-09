(import-macros {: use} :own.macros)
(local {: autoload} (require :nfnl.module))
(local configs (autoload :nvim-treesitter.configs))

(fn config []
  (local additional-vim-regex-highlighting [])
  (local ensure-installed [:bash
                           :clojure
                           :diff
                           :dockerfile
                           :fennel
                           :gitattributes
                           :git_config
                           :graphql
                           :go
                           :gomod
                           :hcl
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
                           :swift
                           :terraform
                           :tsx
                           :typescript
                           :vim
                           :vimdoc
                           :yaml])

  (configs.setup {:highlight {:enable true}
                  :indent {:enable true}
                  :incremental_selection {:enable true
                                          :additional_vim_regex_highlighting additional-vim-regex-highlighting
                                          :keymaps {:init_selection :gnn
                                                    :node_incremental :<tab>
                                                    :node_decremental :<s-tab>
                                                    :scope_incremental :<leader><tab>}}
                  :textobjects {:select {:enable true
                                         :lookahead true
                                         :keymaps {:aa "@parameter.outer"
                                                   :ia "@parameter.inner"
                                                   :af "@function.outer"
                                                   :if "@function.inner"
                                                   :ac "@class.outer"
                                                   :ic "@class.inner"
                                                   :al "@loop.outer"
                                                   :il "@loop.inner"}}}
                  :ensure_installed ensure-installed
                  :table_of_contents {:enable true}}))

[(use :nvim-treesitter/nvim-treesitter-textobjects {:name :nvim-treesitter-textobjects})
 (use :nvim-treesitter/nvim-treesitter
      {:dependencies [:nvim-treesitter-textobjects]
       :build ::TSUpdate
       :config config})

 (use :davidmh/mdx.nvim {:dependencies [:nvim-treesitter/nvim-treesitter]
                         :event "BufRead *.mdx"
                         :config true})]
