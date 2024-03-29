(import-macros {: use} :own.macros)

(use :nvim-telescope/telescope.nvim
     {:dependencies [:nvim-lua/plenary.nvim
                     :nvim-lua/popup.nvim
                     :rcarriga/nvim-notify]
      :event :VeryLazy
      :opts {:defaults {:layout_strategy :horizontal
                        :layout_config {:horizontal {:prompt_position :top
                                                     :preview_width 0.55
                                                     :results_width 0.8}
                                        :vertical {:mirror false}
                                        :width 0.87
                                        :height 0.80
                                        :preview_cutoff 120}
                        :sorting_strategy :ascending
                        :prompt_prefix "   "
                        :selection_caret " "
                        :set_env {:COLORTERM true}
                        :results_title false}
             :pickers {:buffers {:sort_mru true}}}})
