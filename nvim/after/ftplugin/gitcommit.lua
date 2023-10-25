-- [nfnl] Compiled from after/ftplugin/gitcommit.fnl by https://github.com/Olical/nfnl, do not edit.
local function setup_buffer()
  vim.bo.textwidth = 72
  return nil
end
local group = vim.api.nvim_create_augroup("git-commit-buf-enter", {clear = true})
vim.api.nvim_create_autocmd("BufEnter", {callback = setup_buffer, buffer = 0, group = group})
return nil
