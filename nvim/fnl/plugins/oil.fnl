(import-macros {: use} :own.macros)
(local {: border} (require :own.config))
(local {: autoload} (require :nfnl.module))
(local snacks (autoload :snacks))

(vim.api.nvim_create_autocmd :User {:pattern :OilActionsPost
                                    :callback (fn [event]
                                                (when (= event.data.actions.type :move)
                                                  (print (vim.inspect event.data))
                                                  (snacks.rename.on_rename_file event.data.actions.src_url
                                                                                event.data.actions.dest_url)))})

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
