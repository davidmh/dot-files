(import-macros {: use} :own.macros)
(local core (require :nfnl.core))

;; Manage terminal buffers in splits tabs etc
[(use :chomosuke/term-edit.nvim {:ft :toggleterm
                                 :version :1.*
                                 :opts {:prompt_end " ❯ "}})

 (use :akinsho/toggleterm.nvim {:branch :main
                                :dependencies [:chomosuke/term-edit.nvim]
                                :opts {:shade_terminals false
                                       :shell (fn []
                                                (local envrc (-> (vim.fs.find [:.envrc]
                                                                              {:type :file :limit 1})
                                                                 (core.first)))
                                                (if envrc
                                                    (.. "direnv exec . zsh")
                                                    vim.o.shell))}})]
