-- [nfnl] Compiled from fnl/plugins/databases.fnl by https://github.com/Olical/nfnl, do not edit.
local function config()
  vim.g.dbs = {remix_development = "postgres:remix_development"}
  return nil
end
return {"tpope/vim-dadbod", dependencies = {"kristijanhusak/vim-dadbod-ui"}, cmd = {"DB", "DBUIToggle"}, config = config}
