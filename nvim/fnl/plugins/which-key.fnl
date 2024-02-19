(import-macros {: use} :own.macros)
(local {: autoload} (require :nfnl.module))
(local which-key (autoload :which-key))

(use :folke/which-key.nvim {:dependencies [:nvim-lua/plenary.nvim]
                            :event :VeryLazy
                            :config #(which-key.register {:mode [:n]
                                                          :<leader>a {:name :alternate}
                                                          :<leader>g {:name :git
                                                                      :h {:name :hunk}}
                                                          :<leader>l {:name :lsp}
                                                          :<leader>o {:name :org}
                                                          :<leader>b {:name :buffer}
                                                          :<leader>t {:name :toggle}
                                                          :<leader>v {:name :vim}
                                                          :<leader>f {:name :file-tree}
                                                          :<leader>/ {:name :find}
                                                          :<localleader>t {:name :test}})})
