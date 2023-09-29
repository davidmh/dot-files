-- [nfnl] Compiled from fnl/own/plugin/remix.fnl by https://github.com/Olical/nfnl, do not edit.
local ok_3f, remix = pcall(require, "remix")
if ok_3f then
  return remix.setup({})
else
  return nil
end
