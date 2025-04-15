(import-macros {: use} :own.macros)
(local {: autoload} (require :nfnl.module))
(local hover (autoload :hover))

[(use :nvim-tree/nvim-web-devicons {:config true})

 (use :lewis6991/hover.nvim {:opts {:init (fn []
                                            (require :hover.providers.diagnostic)
                                            (require :hover.providers.lsp)
                                            (require :hover.providers.jira)
                                            (require :hover.providers.fold_preview))
                                    :preview_opts {:border :rounded}
                                    :preview_window true
                                    :title false}
                             :keys [(use :K #(hover.hover) {:mode :n})]})]
