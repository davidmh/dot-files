-- [nfnl] Compiled from after/ftplugin/lua.fnl by https://github.com/Olical/nfnl, do not edit.
require("own.fennel-lua-paths"):setup()
if vim.startswith(vim.fn.expand("%:p"), (vim.env.HOME .. "/.config/home-manager/nvim")) then
  vim.bo.readonly = true
  return nil
else
  return nil
end
