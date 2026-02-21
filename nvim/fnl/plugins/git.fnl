(import-macros {: tx} :own.macros)

[(tx :lewis6991/gitsigns.nvim {:opts {:current_line_blame true
                                      :signcolumn true}
                               :config true})

 (tx :tpope/vim-git {:dependencies [:nvim-lua/plenary.nvim
                                    :lewis6991/gitsigns.nvim]
                     :event :VeryLazy})

 (tx :tpope/vim-fugitive {:dependencies [:tpope/vim-rhubarb]
                          :init #(set vim.g.fugitive_legacy_commands false)})

 (tx :esmuellert/codediff.nvim {:dependencies [:MunifTanjim/nui.nvim]
                                :cmd [:CodeDiff]})

 :davidmh/gitattributes.nvim

 (tx :NeogitOrg/neogit {:dependencies [:nvim-lua/plenary.nvim
                                       :esmuellert/codediff.nvim]
                        :opts {:disable_hint true
                               :diff_viewer :codediff
                               :console_timeout 1500
                               :auto_close_console false
                               :fetch_after_checkout true
                               :graph_style :unicode
                               :remember_settings true
                               :ignore_settings [:NeogitPopup--]
                               :notification_icon :
                               :recent_commit_count 15
                               :integrations {:telescope nil}}
                        :event :VeryLazy})]
