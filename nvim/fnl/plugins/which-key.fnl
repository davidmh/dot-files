(import-macros {: use} :own.macros)
(local {: autoload} (require :nfnl.module))
(local which-key (autoload :which-key))

(use :folke/which-key.nvim {:dependencies [:nvim-lua/plenary.nvim]
                            :event :VeryLazy
                            :config #(which-key.add [(use :<leader>g {:group :git})
                                                     (use :<leader>gh {:group :hunk})
                                                     (use :<leader>l {:group :lsp})
                                                     (use :<leader>o {:group :Obsidian})
                                                     (use :<leader>b {:group :buffer})
                                                     (use :<leader>t {:group :toggle})
                                                     (use :<leader>v {:group :vim})
                                                     (use :<leader>/ {:group :find})])})
