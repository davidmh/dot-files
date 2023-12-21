-- [nfnl] Compiled from fnl/plugins/lsp.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local core = autoload("nfnl.core")
local cfg = autoload("own.config")
local util = autoload("lspconfig.util")
local cmp_lsp = autoload("cmp_nvim_lsp")
local json_schemas = autoload("own.json-schemas")
local lspconfig = autoload("lspconfig")
local kind = autoload("lspkind")
local mason = autoload("mason")
local mason_registry = autoload("mason-registry")
local mason_lspconfig = autoload("mason-lspconfig")
local navic = autoload("nvim-navic")
local fidget = autoload("fidget")
local typescript_tools = autoload("typescript-tools")
local function on_linter_install(pkg)
  local function _2_()
    return vim.notify((pkg.name .. " installed"), vim.log.levels.INFO, {title = "mason.nvim"})
  end
  return vim.defer_fn(_2_, 100)
end
local ensure_linters = {"cspell", "luacheck", "selene"}
local function mason_config()
  mason.setup({ui = {border = cfg.border}})
  mason_registry:on("package:install:success", on_linter_install)
  local function _3_()
    for _, name in ipairs(ensure_linters) do
      local pkg = mason_registry.get_package(name)
      if not pkg:is_installed() then
        pkg:install()
      else
      end
    end
    return nil
  end
  return vim.defer_fn(_3_, 100)
end
local function lsp_config()
  typescript_tools.setup({})
  local function _5_(text)
    if (text:match("^it%(") or text:match("^describe%(")) then
      return text:gsub("^it%('", "it "):gsub("^describe%('", "describe "):gsub("'%) callback$", "")
    else
      return text:gsub(" callback$", "")
    end
  end
  navic.setup({depth_limit = 4, depth_limit_indicator = " [ \238\169\188 ] ", click = true, highlight = true, format_text = _5_, icons = cfg["navic-icons"], separator = " \238\170\182 ", safe_output = false})
  kind.init()
  fidget.setup({progress = {display = {done_icon = "\238\174\179"}}, notification = {window = {align = "top", winblend = 0, border = "none", y_padding = 2, zindex = 1}}})
  local win_opts = {border = cfg.border, max_width = 100, separator = true}
  vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, win_opts)
  do end (vim.lsp.handlers)["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, win_opts)
  local git_root = util.root_pattern(".git")
  local client_capabilities = vim.tbl_deep_extend("keep", {textDocument = {foldingRange = {lineFoldingOnly = true, dynamicRegistration = false}}}, vim.lsp.protocol.make_client_capabilities())
  local base_settings = {capabilities = cmp_lsp.default_capabilities(client_capabilities), init_options = {preferences = {includeCompletionsWithSnippetText = true, includeCompletionsForImportStatements = true}}}
  local server_configs = {jsonls = {settings = {json = {schemas = json_schemas["get-all"]()}}}, lua_ls = {settings = {Lua = {completion = "Replace", diagnostics = {globals = {"vim", "it", "describe", "before_each", "after_each", "pending"}}, format = {enable = false}, workspace = {checkThirdParty = false}}}}, eslint = {root_dir = git_root}, grammarly = {filetypes = {"markdown", "norg", "txt", "gitcommit"}}, fennel_language_server = {single_file_support = true, root_dir = lspconfig.util.root_pattern("fnl"), settings = {fennel = {diagnostics = {globals = {"vim", "jit", "comment"}}, workspace = {library = vim.api.nvim_list_runtime_paths()}}}}, cssls = {root_dir = git_root}, shellcheck = {root_dir = git_root}}
  for _, server_name in ipairs(mason_lspconfig.get_installed_servers()) do
    local server_setup = core["get-in"](lspconfig, {server_name, "setup"})
    server_setup(core.merge(base_settings, core.get(server_configs, server_name, {})))
  end
  return lspconfig.solargraph.setup({root_dir = git_root, cmd = {"bundle", "exec", "solargraph", "stdio"}})
end
return {{"j-hui/fidget.nvim", tag = "v1.0.0"}, {"folke/neodev.nvim", opts = {library = {types = true}}, config = true}, {"williamboman/mason.nvim", config = mason_config, lazy = false}, {"williamboman/mason-lspconfig.nvim", opts = {ensure_installed = {"clojure_lsp", "cssls", "jsonls", "lua_ls", "eslint", "fennel_language_server"}}, config = true, lazy = false}, {"neovim/nvim-lspconfig", dependencies = {"williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", "onsails/lspkind-nvim", "hrsh7th/cmp-nvim-lsp", "j-hui/fidget.nvim", "SmiteshP/nvim-navic", "pmizio/typescript-tools.nvim"}, config = lsp_config, event = "VeryLazy"}}
