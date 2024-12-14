(import-macros {: use} :own.macros)

[(use :nvim-tree/nvim-web-devicons {:config true})

 (use :nvim-zh/colorful-winsep.nvim {:config true
                                     :event :VeryLazy})

 (use :stevearc/dressing.nvim {:event :VeryLazy
                               :opts {:select {:backend :telescope}
                                      :telescope {:layout_config {:width #(math.min $2 80)
                                                                  :height #(math.min $2 15)}}}})]
