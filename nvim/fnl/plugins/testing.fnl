(import-macros {: use} :own.macros)
(local {: autoload} (require :nfnl.module))
(local neotest (autoload :neotest))
(local neotest-lib (autoload :neotest.lib))
(local neotest-go (autoload :neotest-go))
(local neotest-python (autoload :neotest-python))
(local neotest-playwright (autoload :neotest-playwright))
(local neotest-playwright-consumers (autoload :neotest-playwright.consumers))

(fn config []
  (set neotest-lib.notify #(-> :noop))
  (neotest.setup {:adapters [neotest-go
                             neotest-python
                             (neotest-playwright.adapter {:options {:preset :headed
                                                                    :persist_project_selection true}})]
                  :consumers {:playwright neotest-playwright-consumers.consumers}
                  :discovery {:enabled false}
                  :benchmark {:enabled true}
                  :icons {:failed :
                          :passed :
                          :running :
                          :watching :}}))

(use :nvim-neotest/neotest {:dependencies [:nvim-lua/plenary.nvim
                                           :antoinemadec/FixCursorHold.nvim
                                           :nvim-treesitter/nvim-treesitter
                                           :nvim-neotest/neotest-go
                                           :nvim-neotest/neotest-python
                                           :thenbe/neotest-playwright]
                            :keys [(use :<localleader>ta #(neotest.playwright.attachment) {:desc :attachments})
                                   (use :<localleader>tr "<cmd>Neotest run<cr>" {:desc :run})
                                   (use :<localleader>ts "<cmd>Neotest summary<cr>" {:desc :summary})
                                   (use :<localleader>to "<cmd>Neotest output<cr>" {:desc :output})
                                   (use :<localleader>tp "<cmd>Neotest output-panel<cr>" {:desc :panel})
                                   (use "]t" "<cmd>Neotest jump next<cr>" {:desc :next})
                                   (use "[t" "<cmd>Neotest jump previous<cr>" {:desc :previous})]
                            : config})
