(import-macros {: use} :own.macros)
(local {: autoload} (require :nfnl.module))
(local notify (autoload :notify))
(local hover (autoload :hover))
(local snacks (autoload :snacks))

[(use :nvim-tree/nvim-web-devicons {:config true})

 (use :rcarriga/nvim-notify {:event :VeryLazy
                             :config #(do (notify.setup {:timeout 2500
                                                         :minimum_width 30
                                                         :top_down false
                                                         :fps 60
                                                         :render :wrapped-compact})
                                          (set vim.notify notify))})

 (use :lewis6991/hover.nvim {:opts {:init (fn []
                                            (require :hover.providers.diagnostic)
                                            (require :hover.providers.lsp)
                                            (require :hover.providers.jira)
                                            (require :hover.providers.fold_preview))
                                    :preview_opts {:border :rounded}
                                    :preview_window true
                                    :title false}
                             :keys [(use :K #(hover.hover) {:mode :n})]})]
