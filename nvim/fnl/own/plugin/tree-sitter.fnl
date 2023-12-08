(local config (require :nvim-treesitter.configs))
(local Comment (require :Comment))
(local hook (require :ts_context_commentstring.integrations.comment_nvim))
(local commentstring (require :ts_context_commentstring))

(set vim.g.skip_ts_context_commentstring_module true)

(commentstring.setup {:highlight true})
(Comment.setup {:pre_hook (hook.create_pre_hook)})

(local additional-vim-regex-highlighting [])
(local ensure-installed [:bash
                         :clojure
                         :diff
                         :fennel
                         :gitattributes
                         :git_config
                         :graphql
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
                         :terraform
                         :tsx
                         :typescript
                         :vim
                         :vimdoc
                         :yaml])

(config.setup {:highlight {:enable true}
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
                                                :ic "@class.inner"}}
                             :move {:enable true
                                    :set_jumps true
                                    :goto_next_start {"]]" "@function.outer"}
                                    :goto_next_end {"][" "@function.outer"}
                                    :goto_previous_start {"[[" "@function.outer"}
                                    :go_to_previous_end {"[]" "@function.outer"}}}
               :ensure_installed ensure-installed
               :table_of_contents {:enable true}})
