(import-macros {: use} :own.macros)
(local {: autoload} (require :nfnl.module))
(local notify (autoload :notify))

[(use :nvim-tree/nvim-web-devicons {:config true})

 (use :rcarriga/nvim-notify {:dependencies [:nvim-telescope/telescope.nvim]
                             :event :VeryLazy
                             :config #(do (notify.setup {:timeout 2500
                                                         :minimum_width 30
                                                         :top_down false
                                                         :fps 60
                                                         :render :wrapped-compact})
                                          (set vim.notify notify))})

 (use :stevearc/dressing.nvim {:event :VeryLazy
                               :opts {:select {:backend :telescope}
                                      :telescope {:layout_config {:width #(math.min $2 80)
                                                                  :height #(math.min $2 15)}}}})]
