-- [nfnl] fnl/plugins/editing.fnl
local function fennel_rules()
  vim.b.switch_custom_definitions = {{["\"\\(\\k\\+\\)\""] = ":\\1", [":\\(\\k\\+\\)"] = "\"\\1\"\\2", fn = "\206\187", ["\206\187"] = "fn"}}
  return nil
end
local function css_rules()
  vim.b.switch_custom_definitions = {{["\\(\\<\\l\\{1,\\}\\)\\(\\u\\l*\\):"] = "\\1-\\l\\2:"}}
  return nil
end
local function config_switch()
  vim.keymap.set("n", "!!", "<Plug>(Switch)", {silent = true})
  local group = vim.api.nvim_create_augroup("custom-switches", {clear = true})
  vim.api.nvim_create_autocmd("FileType", {pattern = "fennel", callback = fennel_rules, group = group})
  vim.api.nvim_create_autocmd("FileType", {pattern = "css,less", callback = css_rules, group = group})
  return nil
end
return {"junegunn/vim-slash", {"mg979/vim-visual-multi", keys = {{"<c-n>", mode = {"n", "v"}}, {"\\\\A", mode = {"n", "v"}}}}, {"willothy/flatten.nvim", opts = {window = {open = "smart"}}, tag = "v0.5.1"}, {"AndrewRadev/switch.vim", config = config_switch, event = "VeryLazy"}, {"tommcdo/vim-exchange", keys = {"cx", "cX", {"X", mode = "v"}}}, {"junegunn/vim-easy-align", keys = {{"ga", "<Plug>(EasyAlign)", mode = {"x", "n"}}}}, {"wakatime/vim-wakatime", lazy = false}}
