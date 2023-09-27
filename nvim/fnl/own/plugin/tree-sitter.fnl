(local config (require :nvim-treesitter.configs))
(local Comment (require :Comment))
(local hook (require :ts_context_commentstring.integrations.comment_nvim))

(local additional-vim-regex-highlighting [])
(local ensure-installed [:bash
                         :fennel
                         :gitattributes
                         :gitcommit
                         :git_config
                         :git_rebase
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

(let [(ok? org-mode) (pcall require :orgmode)]
  (when ok?
    (org-mode.setup_ts_grammar)
    (table.insert ensure-installed :org)
    (table.insert additional-vim-regex-highlighting :org)))

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
               :table_of_contents {:enable true}
               :context_commentstring {:enable true
                                       :enable_autocmd false}})

(Comment.setup {:pre_hook (hook.create_pre_hook)})
