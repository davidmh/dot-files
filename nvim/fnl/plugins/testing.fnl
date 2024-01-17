(import-macros {: use} :own.macros)
(local {: autoload} (require :nfnl.module))
(local neotest (autoload :neotest))
(local neotest-lib (autoload :neotest.lib))
(local neotest-go (autoload :neotest-go))
(local neotest-python (autoload :neotest-python))

(fn config []
  (set neotest-lib.notify #(-> :noop))
  (neotest.setup {:adapters [neotest-go
                             neotest-python]
                  :benchmark {:enabled true}
                  :icons {:failed :
                          :passed :
                          :running :
                          :watching :}}))

(use :nvim-neotest/neotest {:dependencies [:nvim-lua/plenary.nvim
                                           :antoinemadec/FixCursorHold.nvim
                                           :nvim-treesitter/nvim-treesitter
                                           :nvim-neotest/neotest-go
                                           :nvim-neotest/neotest-python]
                            :keys [(use :<localleader>ta "<cmd>Neotest attach<cr>" {:desc :attach})
                                   (use :<localleader>tr "<cmd>Neotest run<cr>" {:desc :run})
                                   (use :<localleader>ts "<cmd>Neotest summary<cr>" {:desc :summary})
                                   (use :<localleader>to "<cmd>Neotest output<cr>" {:desc :output})
                                   (use :<localleader>tp "<cmd>Neotest output-panel<cr>" {:desc :panel})
                                   (use "]t" "<cmd>Neotest jump next<cr>" {:desc :next})
                                   (use "[t" "<cmd>Neotest jump previous<cr>" {:desc :previous})]
                            : config})
