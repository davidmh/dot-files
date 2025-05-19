(import-macros {: tx} :own.macros)
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

[(tx :mfussenegger/nvim-dap {:init config-dap})
 (tx :rcarriga/nvim-dap-ui {:dependencies [:mfussenegger/nvim-dap
                                           :nvim-neotest/nvim-nio]
                            :opts {}
                            :init config-ui
                            :keys [(tx :<localleader>dd #(dap.toggle_breakpoint) {:desc "Toggle Breakpoint"})
                                   (tx :<localleader>dc #(dap.continue) {:desc "Continue"})
                                   (tx :<localleader>di #(dap.step_into) {:desc "Step Into"})
                                   (tx :<localleader>do #(dap.step_out) {:desc "Step Out"})
                                   (tx :<localleader>dt #(dap.terminate) {:desc "Terminate"})
                                   (tx :<localleader>dr #(dap.repl.open) {:desc "Open REPL"})
                                   (tx :<localleader>dh #(dap-widgets.hover) {:desc "Hover"})
                                   (tx :<localleader>dp #(dap-widgets.preview) {:desc "Preview"})
                                   (tx :<localleader>du #(dap-ui.toggle) {:desc "Toggle DAP UI"})]})]

