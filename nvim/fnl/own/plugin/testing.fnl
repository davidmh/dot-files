(local neotest (require :neotest))
(local neotest-rspec (require :neotest-rspec))
(local neotest-plenary (require :neotest-plenary))
(local wk (require :which-key))

(neotest.setup {:adapters [(neotest-rspec {:rspec_cmd [:bundle :exec :rspec]})
                           neotest-plenary]
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
                  :a [#(neotest.run.attach) :attach]
                  :f [#(neotest.run.run (vim.fn.expand :%)) :file]
                  :l [#(neotest.run.run) :line]
                  :c [#(neotest.run.stop) :cancel]
                  :s [#(neotest.summary.toggle) :summary]
                  :o [#(neotest.output_panel.toggle) :output]}}
             {:prefix :<localleader>})
