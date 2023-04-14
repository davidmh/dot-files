(module own.plugin.dap
  {autoload {dap dap
             dap-ui dapui
             dap-virtual-text nvim-dap-virtual-text
             u null-ls.utils
             wk which-key}})

(dap-virtual-text.setup)

;; DAP UI
(dap-ui.setup)

(tset dap.listeners.after.event_initialized :dap_config #(dap-ui.open))
(tset dap.listeners.after.event_terminated :dap_config #(dap-ui.close))
(tset dap.listeners.after.event_exited :dap_config #(dap-ui.close))

;; Signs
(vim.fn.sign_define :DapBreakpoint {:text :
                                    :texthl :DebugBreakpoint
                                    :linehl ""
                                    :numhl :DebugBreakpoint})

(vim.fn.sign_define :DapStopped {:text :
                                 :texthl :DebugHighlight
                                 :linehl ""
                                 :numhl :DebugHighlight})

;; Ruby
(tset dap.adapters :ruby
  (fn [callback config]
    (let [script (if config.current_line
                  (.. config.script ":" (vim.fn.line :.))
                  config.script)
          executable {:command :rdbg
                      :args [:--open :--port "${port}" :-c :-- config.command script]
                      :cwd (u.get_root :Gemfile)}]
      (callback {:type :server
                 :host :127.0.0.1
                 :port "${port}"
                 :executable executable}))))

(tset dap.configurations :ruby [{:type :ruby
                                 :name "debug rspec current_line"
                                 :request :attach
                                 :localfs true
                                 :command :rspec
                                 :script "${file}"
                                 :current_line true}
                                {:type :ruby
                                 :name "debug current file"
                                 :request :attach
                                 :localfs true
                                 :command :rspec
                                 :script "${file}"}])

; TODO: JavaScript/TypeScript
; (tset dap.adapters :pwa-chrome
;   {:type :server
;    :host :localhost
;    :port "${port}"
;    :execute {:command :node
;              :args [(.. (vim.fn.stdpath :data) "/mason")]}})


(wk.register {:d {:name :debug
                  :b [#(dap.toggle_breakpoint) "toggle breakpoint"]
                  :c [#(dap.continue) :continue]
                  :r [#(dap.run_to_cursor) "run to cursor"]
                  :i [#(dap.step_into) "step into"]
                  :o [#(dap.step_over) "step over"]
                  :l [#(dap.run_last) "run last"]
                  :x [#(dap.disconnect) :exit]}}
             {:prefix :<leader>})
