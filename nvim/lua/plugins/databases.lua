-- [nfnl] Compiled from fnl/plugins/databases.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local cmp = autoload("cmp")
local function dadbod_setup()
  vim.bo.omnifunc = "vim_dadbod_completion#omni"
  return cmp.setup.buffer({sources = {{name = "vim-dadbod-completion"}}})
end
local function config()
  vim.g.dbs = {remix_development = "postgres:remix_development"}
  return vim.api.nvim_create_autocmd("FileType", {pattern = "sql", callback = dadbod_setup})
end
return {"tpope/vim-dadbod", dependencies = {"kristijanhusak/vim-dadbod-completion", "kristijanhusak/vim-dadbod-ui", "hrsh7th/nvim-cmp"}, cmd = {"DB", "DBUIToggle"}, config = config}
