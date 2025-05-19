(import-macros {: tx} :own.macros)
(local core (require :nfnl.core))

;; Manage terminal buffers in splits tabs etc
[(tx :chomosuke/term-edit.nvim {:event :TermOpen
                                :version :1.*
                                :opts {:prompt_end "❯ "}})

 (tx :akinsho/toggleterm.nvim {:branch :main
                               :dependencies [:chomosuke/term-edit.nvim]
                               :cmd [:ToggleTerm]
                               :opts {:shade_terminals false
                                      :shell (fn []
                                               (local envrc (-> (vim.fs.find [:.envrc]
                                                                             {:type :file :limit 1})
                                                                (core.first)))
                                               (if envrc
                                                   (.. "direnv exec . zsh")
                                                   vim.o.shell))}})]
