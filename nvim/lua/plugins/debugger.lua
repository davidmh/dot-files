-- [nfnl] Compiled from fnl/plugins/debugger.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local dap = autoload("dap")
local dap_ui = autoload("dapui")
local dap_widgets = autoload("dap.ui.widgets")
local function setup_icon(name, icon)
  return vim.fn.sign_define(name, {text = icon, texthl = name, linehl = name, numhl = name})
end
local function open()
  return dap_ui.open()
end
local function close()
  return dap_ui.close()
end
local function config_ui()
  setup_icon("DapBreakpoint", "\238\174\165")
  setup_icon("DapBreakpointCondition", "\238\172\140")
  setup_icon("DapLogPoint", "\239\132\140")
  setup_icon("DapStopped", "\238\174\137")
  return setup_icon("DapBreakpointRejected", "\238\174\139")
end
local function config_dap()
  dap.listeners.before.attach.dapui_config = open
  dap.listeners.before.launch.dapui_config = open
  dap.listeners.before.event_terminated.dapui_config = close
  dap.listeners.before.event_exited.dapui_config = close
  --[[ (set dap.adapters.ruby (fn [callback config] (callback {:executable {:args ["exec" "rdbg" "-n" "--open" "--port" "${port}" "--c" "--" "bundle" "exec" config.command config.script] :command "bundle"} :host "127.0.0.1" :port "${port}" :type "server"}))) (set dap.configurations.ruby [{:command "rspec" :localfs true :name "run current rspec file" :request "attach" :script "${file}" :type "ruby"}]) ]]
  return nil
end
local function _2_()
  return dap.toggle_breakpoint()
end
local function _3_()
  return dap.continue()
end
local function _4_()
  return dap.step_into()
end
local function _5_()
  return dap.step_out()
end
local function _6_()
  return dap.terminate()
end
local function _7_()
  return dap.repl.open()
end
local function _8_()
  return dap_widgets.hover()
end
local function _9_()
  return dap_widgets.preview()
end
local function _10_()
  return dap_ui.toggle()
end
return {{"mfussenegger/nvim-dap", init = config_dap}, {"rcarriga/nvim-dap-ui", dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"}, opts = {}, init = config_ui, keys = {{"<localleader>dd", _2_, desc = "Toggle Breakpoint"}, {"<localleader>dc", _3_, desc = "Continue"}, {"<localleader>di", _4_, desc = "Step Into"}, {"<localleader>do", _5_, desc = "Step Out"}, {"<localleader>dt", _6_, desc = "Terminate"}, {"<localleader>dr", _7_, desc = "Open REPL"}, {"<localleader>dh", _8_, desc = "Hover"}, {"<localleader>dp", _9_, desc = "Preview"}, {"<localleader>du", _10_, desc = "Toggle DAP UI"}}}}
