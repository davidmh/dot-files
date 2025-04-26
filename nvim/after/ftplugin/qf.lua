-- [nfnl] after/ftplugin/qf.fnl
local _local_1_ = require("own.quickfix")
local set_quickfix_mappings = _local_1_["set-quickfix-mappings"]
vim.wo.number = true
return set_quickfix_mappings()
