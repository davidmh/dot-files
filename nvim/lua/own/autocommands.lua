-- [nfnl] fnl/own/autocommands.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local projects = autoload("own.projects")
local function _2_()
  return vim.lsp.buf.format()
end
vim.api.nvim_create_autocmd("BufWritePre", {pattern = "*.rb", callback = _2_})
local function _3_()
  return projects.add()
end
return vim.api.nvim_create_autocmd("User", {pattern = "RooterChDir", callback = _3_})
