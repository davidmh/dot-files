-- [nfnl] Compiled from fnl/own/plugin/completion.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local cmp = autoload("cmp")
local cmp_git = autoload("cmp_git")
local ls = autoload("luasnip")
local lspkind = autoload("lspkind")
vim.o.completeopt = "menuone,noselect,preview"
cmp_git.setup()
local menu_sources = {path = "(path)", luasnip = "(snip)", nvim_lsp = "(lsp)", emoji = "(emo)", conjure = "(conj)", orgmode = "(org)", nerdfonts = "(font)", buffer = "(buff)", nvim_lua = "(lua)", git = "(git)", omni = "(omni)"}
local v2_symbol_map = {Text = "\238\170\147", Method = "\238\170\140", Function = "\239\158\148", Constructor = "\238\170\140", Field = "\238\173\159", Variable = "\238\170\136", Class = "\238\173\155", Interface = "\238\173\161", Module = "\238\170\139", Property = "\238\173\165", Unit = "\238\170\150", Value = "\238\170\149", Enum = "\238\170\149", Keyword = "\238\173\162", Snippet = "\238\173\166", Color = "\238\173\156", File = "\238\169\187", Reference = "\238\170\148", Folder = "\238\170\131", EnumMember = "\238\170\149", Constant = "\238\173\157", Struct = "\238\170\145", Event = "\238\170\134", Operator = "\238\173\164", TypeParameter = "\238\170\146", Copilot = "\239\132\147"}
local function cmp_format(entry, vim_item)
  local kind_fmt = lspkind.cmp_format({mode = "symbol", menu = menu_sources, maxwidth = 30, symbol_map = v2_symbol_map})
  local kind_item = kind_fmt(entry, vim_item)
  do end (kind_item)["kind"] = (" " .. kind_item.kind .. " ")
  return kind_item
end
local cmd_mappings = {["<C-d>"] = cmp.mapping.scroll_docs(-4), ["<C-f>"] = cmp.mapping.scroll_docs(4), ["<C-Space>"] = cmp.mapping.complete(), ["<C-e>"] = cmp.mapping.close(), ["<C-y>"] = cmp.mapping.confirm({behavior = cmp.ConfirmBehavior.Insert, select = true})}
local function _2_(args)
  return ls.lsp_expand(args.body)
end
cmp.setup({mapping = cmp.mapping.preset.insert(cmd_mappings), sources = cmp.config.sources({{name = "luasnip"}, {name = "nvim_lsp"}, {name = "orgmode"}, {name = "emoji"}, {name = "git"}, {name = "nerdfonts"}, {name = "conjure"}, {name = "buffer", keyword_length = 5}}), formatting = {fields = {"kind", "abbr", "menu"}, format = cmp_format}, snippet = {expand = _2_}, window = {completion = {winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None", col_offset = -3, side_padding = 0}}})
cmp.setup.cmdline({mapping = cmp.mapping.preset.cmdline(cmd_mappings)})
ls.config.setup({history = true, update_events = "TextChanged,TextChangedI", enable_autosnippets = true})
do
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
  local function _6_()
    if ls.expand_or_jumpable() then
      return ls.expand_or_jump()
    else
      return nil
    end
  end
  vim.keymap.set({"i", "s"}, "<c-k>", _6_, opts_1_auto)
end
do
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
  local function _11_()
    if ls.choice_active() then
      return ls.change_choice(1)
    else
      return nil
    end
  end
  vim.keymap.set({"i"}, "<c-l>", _11_, opts_1_auto)
end
local js_log = ls.snippet("debug", {ls.text_node("console.log('DEBUG', { "), ls.insert_node(0), ls.text_node(" });")})
local js_test_case = ls.snippet("it", {ls.text_node("it('"), ls.insert_node(1), ls.text_node("', () => {"), ls.insert_node(0), ls.text_node("});")})
local function _13_()
  return os.date("%Y-%m-%d")
end
ls.add_snippets("all", {ls.snippet("todo", {ls.text_node("TODO(dmejorado): "), ls.insert_node(0)}), ls.snippet("today", ls.function_node(_13_))})
ls.add_snippets("javascript", {js_log, js_test_case})
ls.add_snippets("typescript", {js_log, js_test_case})
ls.add_snippets("typescriptreact", {js_log, js_test_case})
ls.add_snippets("gitcommit", {ls.parser.parse_snippet("cab", "Co-Authored-By: $0")})
return ls.add_snippets("org", {ls.parser.parse_snippet("<s", "#+BEGIN_SRC ${1}\n${0}\n#+END_SRC\n")})
