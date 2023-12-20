(local which-key (require :which-key))

(which-key.setup {})
(which-key.register {:mode [:n]
                     :<leader>g {:name :git}
                     :<leader>l {:name :lsp}
                     :<leader>o {:name :org}
                     :<leader>b {:name :buffer}
                     :<leader>t {:name :toggle}
                     :<leader>v {:name :vim}
                     :<leader>n {:name :neo-tree}
                     :<leader>/ {:name :find}})
