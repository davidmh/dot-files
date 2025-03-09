(import-macros {: use} :own.macros)
(local {: autoload} (require :nfnl.module))
(local {: find-root} (require :own.helpers))
(local neotest (autoload :neotest))
(local neotest-playwright (autoload :neotest-playwright))

(fn rspec-cmd []
  (local direnv-root (find-root :.envrc))
  (local current-file (vim.fn.expand "%"))
  (local root (direnv-root current-file))
  (if root
    [:direnv :exec (vim.fn.expand root) :bundle :exec :rspec]
    [:bundle :exec :rspec]))

(fn neotest-rspec-adapter []
  (local neotest-rspec (require :neotest-rspec))
  (neotest-rspec {:rspec_cmd rspec-cmd}))

(fn config []
  (neotest.setup {:log_level vim.log.levels.DEBUG
                  :adapters [(neotest-rspec-adapter)
                             (require :neotest-rust)
                             (neotest-playwright.adapter {})]
                  :quickfix {:enabled true
                             :open false}
                  :discovery {:enabled false}
                  :icons {:failed :
                          :passed :
                          :running :󰦖
                          :watching :}}))

(use :nvim-neotest/neotest {:dependencies [:nvim-neotest/nvim-nio
                                           :nvim-lua/plenary.nvim
                                           :antoinemadec/FixCursorHold.nvim
                                           :nvim-treesitter/nvim-treesitter
                                           :thenbe/neotest-playwright
                                           :rouge8/neotest-rust
                                           :olimorris/neotest-rspec]
                            :config config
                            :keys [(use :<localleader>trn "<cmd>Neotest run<cr>" {:desc "run nearest test"})
                                   (use :<localleader>trf #(neotest.run.run (vim.fn.expand :%))
                                                          {:desc "run test file"})
                                   (use :<localleader>ts "<cmd>Neotest summary<cr>" {:desc "open test summary"})
                                   (use :<localleader>to "<cmd>Neotest output-panel<cr>" {:desc "open test output"})
                                   (use :<localleader>tjn "<cmd>Neotest jump next<cr>" {:desc "jump to next test"})
                                   (use :<localleader>tjp "<cmd>Neotest jump prev<cr>" {:desc "jump to previous test"})]})
