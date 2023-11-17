-- [nfnl] Compiled from fnl/own/plugin/lsp.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local core = autoload("nfnl.core")
local config = autoload("own.config")
local util = autoload("lspconfig.util")
local cmp_lsp = autoload("cmp_nvim_lsp")
local json_schemas = autoload("own.json-schemas")
local lspconfig = autoload("lspconfig")
local kind = autoload("lspkind")
local mason = autoload("mason")
local mason_lspconfig = autoload("mason-lspconfig")
local navic = autoload("nvim-navic")
local fidget = autoload("fidget")
local typescript_tools = autoload("typescript-tools")
typescript_tools.setup({})
local function _2_(text)
  if (text:match("^it%(") or text:match("^describe%(")) then
    return text:gsub("^it%('", "it "):gsub("^describe%('", "describe "):gsub("'%) callback$", "")
  else
    return text:gsub(" callback$", "")
  end
end
navic.setup({depth_limit = 4, depth_limit_indicator = " [ \238\169\188 ] ", click = true, highlight = true, format_text = _2_, icons = config["navic-icons"], separator = " \238\170\182 ", safe_output = false})
kind.init()
fidget.setup({align = {bottom = false}, text = {spinner = "dots", done = "\238\174\179"}, window = {blend = 0, border = "none", zindex = 1}})
mason.setup({ui = {border = config.border}})
mason_lspconfig.setup({ensure_installed = {"clojure_lsp", "cssls", "jsonls", "lua_ls", "eslint", "denols", "vimls"}, automatic_installation = false})
local win_opts = {border = config.border, max_width = 100, separator = true}
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, win_opts)
do end (vim.lsp.handlers)["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, win_opts)
vim.api.nvim_create_augroup("eslint-autofix", {clear = true})
local function set_eslint_autofix(bufnr)
  return vim.api.nvim_create_autocmd("BufWritePre", {command = "EslintFixAll", group = "eslint-autofix", buffer = bufnr})
end
local function buf_map(keymap, callback, desc)
  return vim.keymap.set("n", keymap, callback, {buffer = true, silent = true, desc = desc})
end
local function on_attach(args)
  local bufnr = args.buf
  local client = vim.lsp.get_client_by_id(args.data.client_id)
  vim.api.nvim_buf_set_option(0, "omnifunc", "v:lua.vim.lsp.omnifunc")
  buf_map("K", vim.lsp.buf.hover, "lsp: hover")
  buf_map("gd", vim.lsp.buf.definition, "lsp: go to definition")
  buf_map("<leader>ld", vim.lsp.buf.declaration, "lsp: go to declaration")
  buf_map("<leader>lf", vim.lsp.buf.references, "lsp: find references")
  buf_map("<leader>li", vim.lsp.buf.implementation, "lsp: go to implementation")
  buf_map("<leader>ls", vim.lsp.buf.signature_help, "lsp: signature")
  buf_map("<leader>lt", vim.lsp.buf.type_definition, "lsp: type definition")
  buf_map("<leader>la", vim.lsp.buf.code_action, "lsp: code actions")
  buf_map("<leader>lr", vim.lsp.buf.rename, "lsp: rename")
  buf_map("<leader>lR", "<cmd>LspRestart<CR>", "lsp: restart")
  local function _4_()
    return vim.lsp.buf.code_action()
  end
  vim.keymap.set("v", "<leader>la", _4_, {buffer = true, desc = "lsp: code actions"})
  if (client.name == "eslint") then
    set_eslint_autofix(bufnr)
  else
  end
  if client.server_capabilities.documentSymbolProvider then
    return navic.attach(client, bufnr)
  else
    return nil
  end
end
local git_root = util.root_pattern(".git")
local ts_root = util.root_pattern("package.json")
local deno_root = util.root_pattern("deno.json", "deno.jsonc")
local client_capabilities = vim.tbl_deep_extend("keep", {textDocument = {foldingRange = {lineFoldingOnly = true, dynamicRegistration = false}}}, vim.lsp.protocol.make_client_capabilities())
local base_settings = {capabilities = cmp_lsp.default_capabilities(client_capabilities), init_options = {preferences = {includeCompletionsWithSnippetText = true, includeCompletionsForImportStatements = true}}}
local server_configs = {vtsls = {root_dir = ts_root, settings = {typescript = {tsdk = "./node_modules/typescript/lib"}}}, jsonls = {settings = {json = {schemas = json_schemas["get-all"]()}}}, lua_ls = {settings = {Lua = {completion = "Replace", diagnostics = {globals = {"vim", "it", "describe", "before_each", "after_each", "pending"}}, workspace = {checkThirdParty = false}}}}, eslint = {root_dir = git_root}, fennel_language_server = {single_file_support = true, root_dir = lspconfig.util.root_pattern("fnl"), settings = {fennel = {diagnostics = {globals = {"vim", "jit", "comment"}}, workspace = {library = vim.api.nvim_list_runtime_paths()}}}}, denols = {root_dir = deno_root}, cssls = {root_dir = git_root}, shellcheck = {root_dir = git_root}}
for _, server_name in ipairs(mason_lspconfig.get_installed_servers()) do
  local server_setup = core["get-in"](lspconfig, {server_name, "setup"})
  server_setup(core.merge(base_settings, core.get(server_configs, server_name, {})))
end
lspconfig.grammarly.setup({filetypes = {"markdown", "norg", "txt", "gitcommit"}})
lspconfig.ruby_ls.setup({root_dir = git_root, cmd = {"bundle", "exec", "ruby-lsp"}})
local group = vim.api.nvim_create_augroup("lsp-attach", {clear = true})
vim.api.nvim_create_autocmd("LspAttach", {callback = on_attach, group = group})
return nil
