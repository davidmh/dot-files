-- [nfnl] Compiled from fnl/plugins/testing.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local _local_2_ = require("own.helpers")
local find_root = _local_2_["find-root"]
local neotest = autoload("neotest")
local function rspec_cmd()
  local direnv_root = find_root(".envrc")
  local current_file = vim.fn.expand("%")
  local root = vim.fn.expand(direnv_root(current_file))
  if root then
    return {"direnv", "exec", root, "bin/rspec"}
  else
    return {"bin/rspec"}
  end
end
local function neotest_rspec_adapter()
  local neotest_rspec = require("neotest-rspec")
  return neotest_rspec({rspec_cmd = rspec_cmd})
end
local function config()
  return neotest.setup({adapters = {neotest_rspec_adapter()}, quickfix = {enabled = true, open = true}, discovery = {enabled = false}, icons = {failed = "\239\145\167", passed = "\239\144\174", running = "\243\176\166\150", watching = "\239\145\129"}})
end
local function _4_()
  return neotest.run.run(vim.fn.expand("%"))
end
return {"nvim-neotest/neotest", dependencies = {"nvim-neotest/nvim-nio", "nvim-lua/plenary.nvim", "antoinemadec/FixCursorHold.nvim", "nvim-treesitter/nvim-treesitter", "olimorris/neotest-rspec"}, config = config, keys = {{"<localleader>trn", "<cmd>Neotest run<cr>", desc = "run nearest test"}, {"<localleader>trf", _4_, desc = "run test file"}, {"<localleader>ts", "<cmd>Neotest summary<cr>", desc = "open test summary"}, {"<localleader>to", "<cmd>Neotest output-panel<cr>", desc = "open test output"}}}
