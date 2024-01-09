(import-macros {: use} :own.macros)
(local {: autoload} (require :nfnl.module))
(local neotest (autoload :neotest))
(local neotest-lib (autoload :neotest.lib))
(local neotest-go (autoload :neotest-go))

(fn config []
  (set neotest-lib.notify #(-> :noop))
  (neotest.setup {:adapters [neotest-go]}))

(use :nvim-neotest/neotest {:dependencies [:nvim-lua/plenary.nvim
                                           :antoinemadec/FixCursorHold.nvim
                                           :nvim-treesitter/nvim-treesitter
                                           :nvim-neotest/neotest-go]
                            :keys [(use :<localleader>ta "<cmd>Neotest attach<cr>" {:desc :attach})
                                   (use :<localleader>tr "<cmd>Neotest run<cr>" {:desc :run})
                                   (use :<localleader>ts "<cmd>Neotest summary<cr>" {:desc :summary})
                                   (use :<localleader>to "<cmd>Neotest output<cr>" {:desc :output})
                                   (use :<localleader>tp "<cmd>Neotest output-panel<cr>" {:desc :panel})]
                            : config})
