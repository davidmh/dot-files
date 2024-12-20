(import-macros {: use} :own.macros)
(local {: border} (require :own.config))

(use :stevearc/oil.nvim {:dependencies [:nvim-tree/nvim-web-devicons]
                         :keys [(use :<leader>fs :<c-w>s<cmd>Oil<cr> {:desc "file explorer in split"})
                                (use :<leader>fv :<c-w>v<cmd>Oil<cr> {:desc "file explorer in vertical split"})
                                (use :<leader>f. :<cmd>Oil<cr> {:desc "file explorer in current window"})]
                         :opts {:keymaps {:<c-h> false ; used to navigate windows
                                          :<c-l> false ; used to navigate windows
                                          :<c-v> (use :actions.select {:opts {:vertical true}})
                                          :<c-s> (use :actions.select {:opts {:horizontal true}})}
                                :view_options {:show_hidden true}
                                :confirmation {:border border}
                                :progress {:border border}
                                :keymaps_help {:border border}}})
