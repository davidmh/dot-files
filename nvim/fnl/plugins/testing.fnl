(import-macros {: tx} :own.macros)
(local {: autoload} (require :nfnl.module))
(local neotest (autoload :neotest))
(local neotest-playwright (autoload :neotest-playwright))

(fn rspec-cmd []
  (local current-file (vim.fn.expand "%"))
  (local root (vim.fs.root current-file :.envrc))
  (if root
    [:direnv :exec (vim.fn.expand root) :bundle :exec :rspec]
    [:bundle :exec :rspec]))

(fn neotest-rspec-adapter []
  (local neotest-rspec (require :neotest-rspec))
  (neotest-rspec {:rspec_cmd rspec-cmd}))

(fn neotest-python-adapter []
  (local neotest-python (require :neotest-python))
  (neotest-python {:python :.venv/bin/python}))

(fn neotest-golang-adapter []
  (local adapter (require :neotest-golang))
  (adapter {:runner :gotestsum}))

(fn config []
  (neotest.setup {:log_level vim.log.levels.DEBUG
                  :adapters [(neotest-rspec-adapter)
                             (require :neotest-rust)
                             (neotest-golang-adapter)
                             (neotest-python-adapter)
                             (neotest-playwright.adapter {})]
                  :quickfix {:enabled true
                             :open false}
                  :discovery {:enabled true}
                  :icons {:failed :
                          :passed :
                          :watching :
                          :running :󰦖
                          :running_animated [:⠋ :⠙ :⠹ :⠸ :⠼ :⠴ :⠦ :⠧ :⠇ :⠏]}}))

(tx :nvim-neotest/neotest {:dependencies [:nvim-neotest/nvim-nio
                                          :nvim-lua/plenary.nvim
                                          :antoinemadec/FixCursorHold.nvim
                                          :nvim-treesitter/nvim-treesitter
                                          :thenbe/neotest-playwright
                                          :rouge8/neotest-rust
                                          :olimorris/neotest-rspec
                                          :nvim-neotest/neotest-python
                                          :fredrikaverpil/neotest-golang]
                           :config config
                           :keys [(tx :<localleader>trn "<cmd>Neotest run<cr>" {:desc "run nearest test"})
                                  (tx :<localleader>trf #(neotest.run.run (vim.fn.expand :%))
                                                        {:desc "run test file"})
                                  (tx :<localleader>ts "<cmd>Neotest summary<cr>" {:desc "open test summary"})
                                  (tx :<localleader>to "<cmd>Neotest output-panel<cr>" {:desc "open test output"})
                                  (tx :<localleader>tjn "<cmd>Neotest jump next<cr>" {:desc "jump to next test"})
                                  (tx :<localleader>tjp "<cmd>Neotest jump prev<cr>" {:desc "jump to previous test"})]})
