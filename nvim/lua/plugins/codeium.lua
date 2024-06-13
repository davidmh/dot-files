-- [nfnl] Compiled from fnl/plugins/codeium.fnl by https://github.com/Olical/nfnl, do not edit.
vim.g.codeium_filetypes = {TelescopePropmt = false, zsh = false}
vim.g.codeium_enabled = true
vim.g.codeium_no_map_tab = true
local expr = true
local silent = true
local function codeium_accept()
  return vim.fn["codeium#Accept"]()
end
local function codeium_next()
  return vim.fn["codeium#CycleCompletions"](1)
end
local function codeium_prev()
  return vim.fn["codeium#CycleCompletions"](-1)
end
local function codeium_dismiss()
  return vim.fn["codeium#Clear"]()
end
local function config()
  vim.keymap.set("i", "<M-y>", codeium_accept, {expr = expr, silent = silent})
  vim.keymap.set("i", "<M-n>", codeium_next, {expr = expr, silent = silent})
  vim.keymap.set("i", "<M-p>", codeium_prev, {expr = expr, silent = silent})
  return vim.keymap.set("i", "<M-c>", codeium_dismiss, {expr = expr, silent = silent})
end
return {"Exafunction/codeium.vim", event = "BufEnter", dependencies = {"nvim-lua/plenary.nvim"}, config = config}
