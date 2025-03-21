(import-macros {: use} :own.macros)
(local {: autoload} (require :nfnl.module))
(local dap (autoload :dap))
(local dap-ui (autoload :dapui))
(local dap-widgets (autoload :dap.ui.widgets))

(fn setup-icon [name icon]
  (vim.fn.sign_define name {:text icon
                            :texthl name
                            :linehl name
                            :numhl name}))

(fn open []
  (dap-ui.open))

(fn close []
  (dap-ui.close))

(fn config-ui []
  (setup-icon :DapBreakpoint :)
  (setup-icon :DapBreakpointCondition :)
  (setup-icon :DapLogPoint :)
  (setup-icon :DapStopped :)
  (setup-icon :DapBreakpointRejected :))

(fn config-dap []
  (set dap.listeners.before.attach.dapui_config open)
  (set dap.listeners.before.launch.dapui_config open)
  (set dap.listeners.before.event_terminated.dapui_config close)
  (set dap.listeners.before.event_exited.dapui_config close)

  (comment
      (set dap.adapters.ruby (fn [callback config]
                               (callback {:type :server
                                          :host :127.0.0.1
                                          :port "${port}"
                                          :executable {:command :bundle
                                                       :args [:exec :rdbg :-n :--open :--port "${port}"
                                                              :--c :-- :bundle :exec config.command config.script]}})))

      (set dap.configurations.ruby [{:type :ruby
                                     :name "run current rspec file"
                                     :request :attach
                                     :localfs true
                                     :command :rspec
                                     :script "${file}"}])))

[(use :mfussenegger/nvim-dap {:init config-dap})
 (use :rcarriga/nvim-dap-ui {:dependencies [:mfussenegger/nvim-dap
                                            :nvim-neotest/nvim-nio]
                             :opts {}
                             :init config-ui
                             :keys [(use :<localleader>dd #(dap.toggle_breakpoint) {:desc "Toggle Breakpoint"})
                                    (use :<localleader>dc #(dap.continue) {:desc "Continue"})
                                    (use :<localleader>di #(dap.step_into) {:desc "Step Into"})
                                    (use :<localleader>do #(dap.step_out) {:desc "Step Out"})
                                    (use :<localleader>dt #(dap.terminate) {:desc "Terminate"})
                                    (use :<localleader>dr #(dap.repl.open) {:desc "Open REPL"})
                                    (use :<localleader>dh #(dap-widgets.hover) {:desc "Hover"})
                                    (use :<localleader>dp #(dap-widgets.preview) {:desc "Preview"})
                                    (use :<localleader>du #(dap-ui.toggle) {:desc "Toggle DAP UI"})]})]

