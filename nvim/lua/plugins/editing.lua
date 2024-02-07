-- [nfnl] Compiled from fnl/plugins/editing.fnl by https://github.com/Olical/nfnl, do not edit.
local function fennel_rules()
  vim.b.switch_custom_definitions = {{["\"\\(\\k\\+\\)\""] = ":\\1", [":\\(\\k\\+\\)"] = "\"\\1\"\\2"}}
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
local function config_easy_align()
  return vim.keymap.set({"x", "n"}, "ga", "<Plug>(EasyAlign)")
end
local function config_mundo()
  vim.o.undofile = true
  vim.o.undodir = (vim.fn.stdpath("data") .. "/undo")
  return nil
end
local function _1_(_241)
  return vim.tbl_contains((_241 or {}), "-d")
end
return {"junegunn/vim-slash", "mg979/vim-visual-multi", {"chrishrb/gx.nvim", keys = {"gx"}, config = true}, {"willothy/flatten.nvim", opts = {window = {open = "smart"}, callbacks = {should_block = _1_}, nest_if_no_args = true}, config = true}, {"AndrewRadev/switch.vim", config = config_switch, event = "VeryLazy"}, {"tommcdo/vim-exchange", keys = {"cx", "cX", "c<Space>", "X"}}, {"junegunn/vim-easy-align", config = config_easy_align, keys = {"ga"}}, {"simnalamburt/vim-mundo", config = config_mundo, event = "VeryLazy"}, {"dhruvasagar/vim-table-mode", ft = "markdown"}}
