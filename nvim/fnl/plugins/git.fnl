(import-macros {: tx} :own.macros)

[(tx :lewis6991/gitsigns.nvim {:opts {:current_line_blame true
                                      :signcolumn true}
                               :config true})

 (tx :sindrets/diffview.nvim {:opts {:key_bindings {:disable_defaults false}}
                              :config true})

 (tx :tpope/vim-git {:dependencies [:nvim-lua/plenary.nvim
                                    :sindrets/diffview.nvim
                                    :lewis6991/gitsigns.nvim]
                     :event :VeryLazy})

 (tx :tpope/vim-fugitive {:dependencies [:tpope/vim-rhubarb]
                          :init #(set vim.g.fugitive_legacy_commands false)})

 (tx :NeogitOrg/neogit {:dependencies [:nvim-lua/plenary.nvim
                                       :sindrets/diffview.nvim]
                        :opts {:disable_hint true
                               :auto_close_console false
                               :fetch_after_checkout true
                               :graph_style :unicode
                               :remember_settings true
                               :ignore_settings [:NeogitPopup--]
                               :notification_icon :
                               :recent_commit_count 15
                               :integrations {:telescope nil}}
                        :cmd [:Neogit :NeogitLogCurrent]})]
