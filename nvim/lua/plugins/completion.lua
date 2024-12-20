-- [nfnl] Compiled from fnl/plugins/completion.fnl by https://github.com/Olical/nfnl, do not edit.
vim.opt.completeopt = {"menuone", "menuone", "noselect", "popup"}
local function _1_(ctx)
  return (" " .. ctx.kind_icon .. " ")
end
local function _2_(ctx)
  return (ctx.label .. " ")
end
return {"Saghen/blink.cmp", dependencies = {"kristijanhusak/vim-dadbod-completion"}, version = "v0.*", opts = {appearance = {nerd_font_variant = "mono"}, completion = {menu = {draw = {components = {kind_icon = {text = _1_}, label = {text = _2_}}, padding = 0}}}, sources = {default = {"lazydev", "lsp", "path", "snippets", "buffer", "dadbod"}, providers = {dadbod = {name = "Dadbod", module = "vim_dadbod_completion.blink"}, lazydev = {name = "LazyDev", module = "lazydev.integrations.blink", score_offset = 100}}}}}
