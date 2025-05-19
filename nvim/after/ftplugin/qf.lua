-- [nfnl] after/ftplugin/qf.fnl
local _local_1_ = require("own.quickfix")
local set_quickfix_mappings = _local_1_["set-quickfix-mappings"]
vim.wo.number = true
set_quickfix_mappings()
vim.g.qf_bufnr = vim.api.nvim_get_current_buf()
local function _2_()
  vim.g.qf_bufnr = nil
  return (nil or true)
end
return vim.api.nvim_create_autocmd("WinClosed", {buffer = vim.g.qf_bufnr, callback = _2_})
