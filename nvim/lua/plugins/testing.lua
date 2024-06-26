-- [nfnl] Compiled from fnl/plugins/testing.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local neotest = autoload("neotest")
local neotest_lib = autoload("neotest.lib")
local neotest_go = autoload("neotest-go")
local neotest_python = autoload("neotest-python")
local neotest_playwright = autoload("neotest-playwright")
local neotest_rspec = autoload("neotest-rspec")
local neotest_playwright_consumers = autoload("neotest-playwright.consumers")
local neotest_rust = autoload("neotest-rust")
local function config()
  local function _2_()
    return "noop"
  end
  neotest_lib.notify = _2_
  return neotest.setup({adapters = {neotest_go, neotest_python, neotest_rspec, neotest_rust, neotest_playwright.adapter({options = {preset = "headed", persist_project_selection = true}})}, consumers = {playwright = neotest_playwright_consumers.consumers}, discovery = {enabled = false}, benchmark = {enabled = true}, icons = {failed = "\239\145\167", passed = "\239\144\174", running = "\239\145\170", watching = "\239\145\129"}})
end
return {"nvim-neotest/neotest", dependencies = {"nvim-lua/plenary.nvim", "antoinemadec/FixCursorHold.nvim", "nvim-treesitter/nvim-treesitter", "nvim-neotest/nvim-nio", "nvim-neotest/neotest-go", "nvim-neotest/neotest-python", "thenbe/neotest-playwright", "olimorris/neotest-rspec", "rouge8/neotest-rust"}, keys = {{"<localleader>ta", "<cmd>Neotest attach<cr>", desc = "attach"}, {"<localleader>trf", "<cmd>Neotest run file<cr>", desc = "run file"}, {"<localleader>trl", "<cmd>Neotest run<cr>", desc = "run current line"}, {"<localleader>ts", "<cmd>Neotest summary<cr>", desc = "summary"}, {"<localleader>to", "<cmd>Neotest output<cr>", desc = "output"}, {"<localleader>tp", "<cmd>Neotest output-panel<cr>", desc = "panel"}, {"]t", "<cmd>Neotest jump next<cr>", desc = "next"}, {"[t", "<cmd>Neotest jump previous<cr>", desc = "previous"}}, config = config}
