-- [nfnl] Compiled from after/ftplugin/norg.fnl by https://github.com/Olical/nfnl, do not edit.
local function setup_buffer()
  vim.wo.conceallevel = 3
  if (vim.api.nvim_buf_get_name(0) == "neorg://toc") then
    return vim.api.nvim_win_set_width(0, 50)
  else
    return nil
  end
end
local group = vim.api.nvim_create_augroup("neorg-buf-enter", {clear = true})
vim.api.nvim_create_autocmd("BufEnter", {callback = setup_buffer, group = group})
return nil
