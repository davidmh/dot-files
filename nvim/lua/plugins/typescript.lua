-- [nfnl] fnl/plugins/typescript.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_.autoload
local bm = autoload("tsc.better-messages")
local function translate_diagnostic(diagnostic)
  diagnostic.message = bm.translate(("TS" .. diagnostic.code .. ": " .. diagnostic.message))
  return diagnostic
end
local function published_diagnostics(err, res, ctx, config)
  res.diagnostics = vim.tbl_map(translate_diagnostic, res.diagnostics)
  return vim.lsp.diagnostic.on_publish_diagnostics(err, res, ctx, config)
end
return {{"dmmulroy/tsc.nvim", opts = {auto_open_qflist = true, auto_focus_qflist = true}}, {"pmizio/typescript-tools.nvim", dependencies = {"nvim-lua/plenary.nvim"}, opts = {settings = {expose_as_code_action = {"add_missing_imports"}}, root_markers = {"tsconfig.json"}, handlers = {["textDocument/publishDiagnostics"] = published_diagnostics}}}}
