(import-macros {: autocmd : use} :own.macros)
(local {: autoload} (require :nfnl.module))
(local notify (autoload :notify))

(fn config-beacon []
  (autocmd :FocusGained {:pattern :* :command :Beacon}))

[(use :danilamihailov/beacon.nvim {:config config-beacon})

 (use :nvim-tree/nvim-web-devicons {:opts {:override {:scm {:color :#A6E3A1
                                                            :name :query
                                                            :icon :󰘧}
                                                      :fnl {:color :teal
                                                            :name :blue
                                                            :icon :}
                                                      :norg {:icon :}}}
                                    :config true})

 (use :stevearc/dressing.nvim {:event :VeryLazy
                               :opts {:select {:backend :telescope}
                                      :telescope {:layout_config {:width #(math.min $2 80)
                                                                  :height #(math.min $2 15)}}}})

 (use :rcarriga/nvim-notify {:dependencies [:nvim-telescope/telescope.nvim]
                             :event :VeryLazy
                             :config #(do (notify.setup {:timeout 2500
                                                         :minimum_width 30
                                                         :top_down false
                                                         :fps 60
                                                         :render :wrapped-compact})
                                          (set vim.notify notify))})]
