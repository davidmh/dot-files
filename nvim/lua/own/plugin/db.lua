-- [nfnl] Compiled from fnl/own/plugin/db.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local cmp = autoload("cmp")
vim.g.dbs = {remix_development = "postgres:remix_development"}
local function dadbod_setup()
  vim.bo.omnifunc = "vim_dadbod_completion#omni"
  return cmp.setup.buffer({sources = {{name = "vim-dadbod-completion"}}})
end
return vim.api.nvim_create_autocmd("FileType", {pattern = "sql", callback = dadbod_setup})
