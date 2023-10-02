-- [nfnl] Compiled from fnl/own/plugin/switch.fnl by https://github.com/Olical/nfnl, do not edit.
local function fennel_rules()
  vim.b.switch_custom_definitions = {{["\"\\(\\k\\+\\)\""] = ":\\1", [":\\(\\k\\+\\)"] = "\"\\1\"\\2"}}
  return nil
end
local function css_rules()
  vim.b.switch_custom_definitions = {{["\\(\\<\\l\\{1,\\}\\)\\(\\u\\l*\\):"] = "\\1-\\l\\2:"}}
  return nil
end
do
  local group = vim.api.nvim_create_augroup("custom-switches", {clear = true})
  vim.api.nvim_create_autocmd("FileType", {pattern = "fennel", callback = fennel_rules, group = group})
  vim.api.nvim_create_autocmd("FileType", {pattern = "css,less", callback = css_rules, group = group})
end
return vim.keymap.set("n", "!!", "<Plug>(Switch)")
