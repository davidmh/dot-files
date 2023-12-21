(import-macros {: use} :own.macros)

;; Manage terminal buffers in splits tabs etc
[(use :chomosuke/term-edit.nvim {:ft :toggleterm
                                 :version :1.*
                                 :opts {:prompt_end " [ "}})

 (use :akinsho/toggleterm.nvim {:branch :main
                                :dependencies [:chomosuke/term-edit.nvim]
                                :opts {:shade_terminals false}})]
