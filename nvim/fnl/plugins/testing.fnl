(import-macros {: use} :own.macros)
(local {: autoload} (require :nfnl.module))
(local {: find-root} (require :own.helpers))
(local neotest (autoload :neotest))

(fn rspec-cmd []
  (local direnv-root (find-root :.envrc))
  (local current-file (vim.fn.expand "%"))
  (local root (vim.fn.expand (direnv-root current-file)))
  (if root
    [:direnv :exec root :bin/rspec]
    [:bin/rspec]))

(fn neotest-rspec-adapter []
  (local neotest-rspec (require :neotest-rspec))
  (neotest-rspec {:rspec_cmd rspec-cmd}))

(fn config []
  (neotest.setup {:adapters [(neotest-rspec-adapter)]
                  :quickfix {:enabled true
                             :open true}
                  :discovery {:enabled false}
                  :icons {:failed :
                          :passed :
                          :running :󰦖
                          :watching :}}))

(use :nvim-neotest/neotest {:dependencies [:nvim-neotest/nvim-nio
                                           :nvim-lua/plenary.nvim
                                           :antoinemadec/FixCursorHold.nvim
                                           :nvim-treesitter/nvim-treesitter
                                           :olimorris/neotest-rspec]
                            :config config
                            :keys [(use :<localleader>trn "<cmd>Neotest run<cr>" {:desc "run nearest test"})
                                   (use :<localleader>trf "<cmd>Neotest run file<cr>" {:desc "run test file"})
                                   (use :<localleader>ts "<cmd>Neotest summary<cr>" {:desc "open test summary"})
                                   (use :<localleader>to "<cmd>Neotest output-panel<cr>" {:desc "open test output"})]})
