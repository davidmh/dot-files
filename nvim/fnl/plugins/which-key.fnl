(import-macros {: use} :own.macros)
(local {: autoload} (require :nfnl.module))
(local which-key (autoload :which-key))

(use :folke/which-key.nvim {:dependencies [:nvim-lua/plenary.nvim]
                            :event :VeryLazy
                            :config #(which-key.register {:mode [:n]
                                                          :<leader>g {:name :git}
                                                          :<leader>l {:name :lsp}
                                                          :<leader>o {:name :org}
                                                          :<leader>b {:name :buffer}
                                                          :<leader>t {:name :toggle}
                                                          :<leader>v {:name :vim}
                                                          :<leader>n {:name :neo-tree}
                                                          :<leader>/ {:name :find}})})
