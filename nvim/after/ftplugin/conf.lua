-- [nfnl] Compiled from after/ftplugin/conf.fnl by https://github.com/Olical/nfnl, do not edit.
local _1_ = vim.split(vim.fn.expand("%:t"), ".", {plain = true})
if ((_G.type(_1_) == "table") and ((_1_)[1] == "DOCKERFILE")) then
  vim.bo.ft = "dockerfile"
  return nil
elseif ((_G.type(_1_) == "table") and true and ((_1_)[2] == "rbi")) then
  local _ = (_1_)[1]
  vim.bo.ft = "ruby"
  return nil
else
  return nil
end
