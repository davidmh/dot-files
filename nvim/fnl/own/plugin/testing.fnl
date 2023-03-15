(module own.plugin.testing
  {autoload {neotest neotest
             neotest-rspec neotest-rspec
             wk which-key}})

(neotest.setup {:adapters [(neotest-rspec {:rspec_cmd [:bundle :exec :rspec]})]
                :discovery {:enabled false}
                :icons {:failed :
                        :passed :}
                :log_level vim.diagnostic.severity.HINT
                :status {:enabled true
                         :signs false
                         :virtual_text true}
                :quickfix {:enabled true
                           :open false}})

(wk.register {:t {:name :test
                  :f [#(neotest.run.run (vim.fn.expand :%)) :file]
                  :l [#(neotest.run.run) :line]
                  :s [#(neotest.run.stop) :stop]
                  :t [#(neotest.summary.toggle) :open]}}
             {:prefix :<localleader>})
