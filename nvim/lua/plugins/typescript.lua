-- [nfnl] fnl/plugins/typescript.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_.autoload
local tsc_utils = autoload("tsc.utils")
local function _2_(...)
  return tsc_utils.text_document_published_diagnostics_handler(...)
end
return {{"davidmh/tsc.nvim", opts = {auto_open_qflist = true, auto_focus_qflist = true}, branch = "combined-prs"}, {"pmizio/typescript-tools.nvim", dependencies = {"nvim-lua/plenary.nvim"}, opts = {settings = {expose_as_code_action = {"add_missing_imports"}}, root_markers = {"tsconfig.json"}, handlers = {["textDocument/publishDiagnostics"] = _2_}}}}
