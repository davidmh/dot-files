-- [nfnl] fnl/plugins/completion.fnl
local _local_1_ = require("nfnl.core")
local concat = _local_1_["concat"]
local merge = _local_1_["merge"]
local _local_2_ = require("nfnl.module")
local autoload = _local_2_["autoload"]
local cmp = autoload("cmp")
local ls = autoload("luasnip")
local lspkind = autoload("lspkind")
local vscode_loader = autoload("luasnip.loaders.from_vscode")
vim.opt.completeopt = {"menuone", "menuone", "noselect"}
local function cmp_format(entry, vim_item)
  local kind_fmt = lspkind.cmp_format({mode = "symbol", maxwidth = 30})
  local kind_item = kind_fmt(entry, vim_item)
  kind_item["kind"] = (" " .. kind_item.kind .. " ")
  return kind_item
end
local function config()
  local cmd_mappings = {["<C-d>"] = cmp.mapping.scroll_docs(-4), ["<C-f>"] = cmp.mapping.scroll_docs(4), ["<C-Space>"] = cmp.mapping.complete(), ["<C-e>"] = cmp.mapping.close(), ["<C-y>"] = cmp.mapping.confirm({behavior = cmp.ConfirmBehavior.Insert, select = true})}
  local base_opts
  local function _3_(args)
    return ls.lsp_expand(args.body)
  end
  base_opts = {mapping = cmp.mapping.preset.insert(cmd_mappings), sources = cmp.config.sources({{name = "luasnip"}, {name = "nvim_lsp"}, {name = "emoji"}, {name = "nerdfonts"}, {name = "conjure"}, {name = "buffer", keyword_length = 5}}), formatting = {fields = {"kind", "abbr", "menu"}, format = cmp_format}, snippet = {expand = _3_}, window = {completion = {winhighlight = "Normal:Pmenu,FloatBorder:Pmenu,Search:None", col_offset = -3, side_padding = 0}}}
  cmp.setup(base_opts)
  cmp.setup.filetype({"r"}, merge(base_opts, {sources = concat(cmp.config.sources({{name = "cmp_r"}}), base_opts.sources)}))
  cmp.setup.filetype({"markdown"}, merge(base_opts, {sources = concat(cmp.config.sources({{name = "obsidian"}, {name = "obsidian_new"}, {name = "obsidian_tags"}}), base_opts.sources)}))
  cmp.setup.filetype({"sql"}, merge(base_opts, {sources = concat(cmp.config.sources({{name = "vim-dadbod-completion"}}), base_opts.sources)}))
  cmp.setup.filetype({"gitcommit"}, merge(base_opts, {sources = concat(cmp.config.sources({{name = "git-co-authors"}}), base_opts.sources)}))
  cmp.setup.cmdline({mapping = cmp.mapping.preset.cmdline(cmd_mappings)})
  ls.config.setup({history = true, update_events = "TextChanged,TextChangedI", enable_autosnippets = true})
  vscode_loader.lazy_load()
  local function _4_()
    if ls.expand_or_jumpable() then
      return ls.expand_or_jump()
    else
      return nil
    end
  end
  vim.keymap.set({"i", "s"}, "<c-k>", _4_)
  local function _6_()
    if ls.choice_active() then
      return ls.change_choice(-1)
    else
      return nil
    end
  end
  vim.keymap.set({"i"}, "<c-h>", _6_)
  local function _8_()
    if ls.choice_active() then
      return ls.change_choice(1)
    else
      return nil
    end
  end
  vim.keymap.set({"i"}, "<c-l>", _8_)
  local js_log = ls.parser.parse_snippet("debug", "console.log('DEBUG', { $0 });")
  local co_authored_by = ls.parser.parse_snippet("cab", "Co-authored-by: $0")
  local function _10_()
    return os.date("%Y-%m-%d")
  end
  ls.add_snippets("all", {ls.parser.parse_snippet("todo", "TODO: $0"), ls.snippet("date", ls.function_node(_10_))})
  ls.add_snippets("javascript", {js_log})
  ls.add_snippets("typescript", {js_log})
  ls.add_snippets("typescriptreact", {js_log})
  ls.add_snippets("gitcommit", {co_authored_by})
  return ls.add_snippets("org", {ls.parser.parse_snippet("<s", "#+BEGIN_SRC ${1}\n${0}\n#+END_SRC\n")})
end
return {{"hrsh7th/nvim-cmp", dependencies = {"hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "PaterJason/cmp-conjure", "saadparwaiz1/cmp_luasnip", "L3MON4D3/LuaSnip", "davidmh/cmp-nerdfonts", "davidmh/cmp-git-co-authors", "onsails/lspkind-nvim", "hrsh7th/cmp-emoji", "rafamadriz/friendly-snippets", "kristijanhusak/vim-dadbod-completion"}, event = "InsertEnter", config = config}}
