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
local opts_1_auto
do
  local tbl_14_auto = {}
  for k_2_auto, v_3_auto in pairs((nil or {})) do
    local k_15_auto, v_16_auto = k_2_auto, v_3_auto
    if ((k_15_auto ~= nil) and (v_16_auto ~= nil)) then
      tbl_14_auto[k_15_auto] = v_16_auto
    else
    end
  end
  opts_1_auto = tbl_14_auto
end
if (opts_1_auto.noremap == nil) then
  opts_1_auto.noremap = true
else
end
if (opts_1_auto.silent == nil) then
  opts_1_auto.silent = true
else
end
return vim.keymap.set("n", "!!", "<Plug>(Switch)", opts_1_auto)
