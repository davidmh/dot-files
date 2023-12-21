(import-macros {: use} :own.macros)
(local {: autoload} (require :nfnl.module))
(local notify (autoload :notify))

[:danilamihailov/beacon.nvim

 (use :nvim-tree/nvim-web-devicons {:opts {:override {:scm {:color :#A6E3A1
                                                            :name :query
                                                            :icon :󰘧}
                                                      :fnl {:color :cyan
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
                                                         :fps 60})
                                          (set vim.notify notify))})

 (use :folke/noice.nvim {:config true
                         :event :VeryLazy
                         :opts {:lsp {:override {:vim.lsp.util.convert_input_to_markdown_lines true
                                                 :vim.lsp.util.stylize_markdown true
                                                 :cmp.entry.get_documentation true}}}
                         :dependencies [:MunifTanjim/nui.nvim
                                        :rcarriga/nvim-notify]})]

