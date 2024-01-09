-- [nfnl] Compiled from fnl/plugins/testing.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local neotest = autoload("neotest")
local neotest_lib = autoload("neotest.lib")
local neotest_go = autoload("neotest-go")
local function config()
  local function _2_()
    return "noop"
  end
  neotest_lib.notify = _2_
  return neotest.setup({adapters = {neotest_go}})
end
return {"nvim-neotest/neotest", dependencies = {"nvim-lua/plenary.nvim", "antoinemadec/FixCursorHold.nvim", "nvim-treesitter/nvim-treesitter", "nvim-neotest/neotest-go"}, keys = {{"<localleader>ta", "<cmd>Neotest attach<cr>", desc = "attach"}, {"<localleader>tr", "<cmd>Neotest run<cr>", desc = "run"}, {"<localleader>ts", "<cmd>Neotest summary<cr>", desc = "summary"}, {"<localleader>to", "<cmd>Neotest output<cr>", desc = "output"}, {"<localleader>tp", "<cmd>Neotest output-panel<cr>", desc = "panel"}}, config = config}
