-- [nfnl] Compiled from fnl/plugins/completion.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local cmp = autoload("cmp")
local ls = autoload("luasnip")
local lspkind = autoload("lspkind")
local from_vscode = autoload("luasnip.loaders.from_vscode")
vim.o.completeopt = "menuone,noselect,preview"
local function cmp_format(entry, vim_item)
  local kind_fmt = lspkind.cmp_format({mode = "symbol", maxwidth = 30})
  local kind_item = kind_fmt(entry, vim_item)
  do end (kind_item)["kind"] = (" " .. kind_item.kind .. " ")
  return kind_item
end
local co_author_domain_ranking = vim.tbl_add_reverse_lookup({"users.noreply.github.com", "ridewithvia.com", "remix.com", "gmail.com"})
local function config()
  from_vscode.lazy_load()
  local cmd_mappings = {["<C-d>"] = cmp.mapping.scroll_docs(-4), ["<C-f>"] = cmp.mapping.scroll_docs(4), ["<C-Space>"] = cmp.mapping.complete(), ["<C-e>"] = cmp.mapping.close(), ["<C-y>"] = cmp.mapping.confirm({behavior = cmp.ConfirmBehavior.Insert, select = true})}
  local function _2_(args)
    return ls.lsp_expand(args.body)
  end
  cmp.setup({mapping = cmp.mapping.preset.insert(cmd_mappings), sources = cmp.config.sources({{name = "git-co-authors", option = {domain_ranking = co_author_domain_ranking, since_date = "2 weeks"}}, {name = "luasnip"}, {name = "nvim_lsp"}, {name = "cmp_nvim_r"}, {name = "orgmode"}, {name = "emoji"}, {name = "nerdfonts"}, {name = "conjure"}, {name = "buffer", keyword_length = 5}}), formatting = {fields = {"kind", "abbr", "menu"}, format = cmp_format}, snippet = {expand = _2_}, window = {completion = {winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None", col_offset = -3, side_padding = 0}}})
  cmp.setup.cmdline({mapping = cmp.mapping.preset.cmdline(cmd_mappings)})
  ls.config.setup({history = true, update_events = "TextChanged,TextChangedI", enable_autosnippets = true})
  local function _3_()
    if ls.expand_or_jumpable() then
      return ls.expand_or_jump()
    else
      return nil
    end
  end
  vim.keymap.set({"i", "s"}, "<c-k>", _3_)
  local function _5_()
    if ls.choice_active() then
      return ls.change_choice(-1)
    else
      return nil
    end
  end
  vim.keymap.set({"i"}, "<c-h>", _5_)
  local function _7_()
    if ls.choice_active() then
      return ls.change_choice(1)
    else
      return nil
    end
  end
  vim.keymap.set({"i"}, "<c-l>", _7_)
  local js_log = ls.parser.parse_snippet("debug", "console.log('DEBUG', { $0 });")
  local co_authored_by = ls.parser.parse_snippet("cab", "Co-authored-by: $0")
  local function _9_()
    return os.date("%Y-%m-%d")
  end
  ls.add_snippets("all", {ls.snippet("todo", {ls.text_node("TODO(dmejorado): "), ls.insert_node(0)}), ls.snippet("today", ls.function_node(_9_))})
  ls.add_snippets("javascript", {js_log})
  ls.add_snippets("typescript", {js_log})
  ls.add_snippets("typescriptreact", {js_log})
  ls.add_snippets("gitcommit", {co_authored_by})
  return ls.add_snippets("org", {ls.parser.parse_snippet("<s", "#+BEGIN_SRC ${1}\n${0}\n#+END_SRC\n")})
end
return {"hrsh7th/nvim-cmp", dependencies = {"hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "PaterJason/cmp-conjure", "saadparwaiz1/cmp_luasnip", "L3MON4D3/LuaSnip", "davidmh/cmp-nerdfonts", "onsails/lspkind-nvim", "hrsh7th/cmp-emoji", "jalvesaq/cmp-nvim-r", "rafamadriz/friendly-snippets", "davidmh/cmp-git-co-authors"}, config = config}
