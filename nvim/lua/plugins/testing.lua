-- [nfnl] fnl/plugins/testing.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local _local_2_ = require("own.helpers")
local find_root = _local_2_["find-root"]
local neotest = autoload("neotest")
local neotest_playwright = autoload("neotest-playwright")
local function rspec_cmd()
  local direnv_root = find_root(".envrc")
  local current_file = vim.fn.expand("%")
  local root = direnv_root(current_file)
  if root then
    return {"direnv", "exec", vim.fn.expand(root), "bundle", "exec", "rspec"}
  else
    return {"bundle", "exec", "rspec"}
  end
end
local function neotest_rspec_adapter()
  local neotest_rspec = require("neotest-rspec")
  return neotest_rspec({rspec_cmd = rspec_cmd})
end
local function neotest_python_adapter()
  local neotest_python = require("neotest-python")
  return neotest_python({python = ".venv/bin/python"})
end
local function config()
  return neotest.setup({log_level = vim.log.levels.DEBUG, adapters = {neotest_rspec_adapter(), require("neotest-rust"), require("neotest-go"), neotest_python_adapter(), neotest_playwright.adapter({})}, quickfix = {enabled = true, open = false}, discovery = {enabled = false}, icons = {failed = "\239\145\167", passed = "\239\144\174", running = "\243\176\166\150", watching = "\239\145\129"}})
end
local function _4_()
  return neotest.run.run(vim.fn.expand("%"))
end
return {"nvim-neotest/neotest", dependencies = {"nvim-neotest/nvim-nio", "nvim-lua/plenary.nvim", "antoinemadec/FixCursorHold.nvim", "nvim-treesitter/nvim-treesitter", "thenbe/neotest-playwright", "rouge8/neotest-rust", "olimorris/neotest-rspec", "nvim-neotest/neotest-python", "nvim-neotest/neotest-go"}, config = config, keys = {{"<localleader>trn", "<cmd>Neotest run<cr>", desc = "run nearest test"}, {"<localleader>trf", _4_, desc = "run test file"}, {"<localleader>ts", "<cmd>Neotest summary<cr>", desc = "open test summary"}, {"<localleader>to", "<cmd>Neotest output-panel<cr>", desc = "open test output"}, {"<localleader>tjn", "<cmd>Neotest jump next<cr>", desc = "jump to next test"}, {"<localleader>tjp", "<cmd>Neotest jump prev<cr>", desc = "jump to previous test"}}}
