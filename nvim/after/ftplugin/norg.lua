-- [nfnl] after/ftplugin/norg.fnl
local function setup_buffer()
  vim.wo.conceallevel = 3
  return nil
end
local group = vim.api.nvim_create_augroup("neorg-buf-enter", {clear = true})
vim.api.nvim_create_autocmd("BufEnter", {callback = setup_buffer, group = group})
return nil
