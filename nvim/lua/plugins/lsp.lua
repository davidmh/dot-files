-- [nfnl] Compiled from fnl/plugins/lsp.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local core = autoload("nfnl.core")
local cfg = autoload("own.config")
local util = autoload("lspconfig.util")
local cmp_lsp = autoload("cmp_nvim_lsp")
local schema_store = autoload("schemastore")
local lspconfig = autoload("lspconfig")
local mason = autoload("mason")
local mason_registry = autoload("mason-registry")
local mason_lspconfig = autoload("mason-lspconfig")
local function on_linter_install(pkg)
  local function _2_()
    return vim.notify((pkg.name .. " installed"), vim.log.levels.INFO, {title = "mason.nvim"})
  end
  return vim.defer_fn(_2_, 100)
end
local ensure_linters = {"cspell", "luacheck", "selene", "stylua"}
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
  local git_root = util.root_pattern(".git")
  local client_capabilities = vim.lsp.protocol.make_client_capabilities()
  local base_settings = {capabilities = cmp_lsp.default_capabilities(client_capabilities), init_options = {preferences = {includeCompletionsWithSnippetText = true, includeCompletionsForImportStatements = true}}}
  local server_configs = {jsonls = {settings = {json = {schemas = schema_store.json.schemas(), validate = {enable = true}}}}, lua_ls = {settings = {Lua = {completion = {callSnippet = "Replace"}, diagnostics = {globals = {"vim", "it", "describe", "before_each", "after_each", "pending"}}, format = {enable = false}, workspace = {checkThirdParty = false}}}}, eslint = {root_dir = git_root}, grammarly = {filetypes = {"markdown", "norg", "txt", "gitcommit"}}, fennel_language_server = {single_file_support = true, root_dir = lspconfig.util.root_pattern("fnl"), settings = {fennel = {diagnostics = {globals = {"vim", "jit", "comment"}}, workspace = {library = vim.api.nvim_list_runtime_paths()}}}}, cssls = {root_dir = git_root}, shellcheck = {root_dir = git_root}}
  for _, server_name in ipairs(mason_lspconfig.get_installed_servers()) do
    local server_setup = core["get-in"](lspconfig, {server_name, "setup"})
    local server_config = core.get(server_configs, server_name, {})
    if (server_name == "gopls") then
      server_setup(server_config)
    else
      server_setup(core.merge(base_settings, server_config))
    end
  end
  return nil
end
local function _6_(text)
  if (text:match("^it%(") or text:match("^describe%(")) then
    return text:gsub("^it%('", "it "):gsub("^describe%('", "describe "):gsub("'%) callback$", "")
  else
    return text:gsub(" callback$", "")
  end
end
return {{"folke/lazydev.nvim", ft = "lua", opts = {library = {(vim.env.LAZY .. "/luvit-meta/library")}}, config = true}, {"Bilal2453/luvit-meta", lazy = true}, {"williamboman/mason.nvim", config = mason_config}, {"williamboman/mason-lspconfig.nvim", dependencies = {"williamboman/mason.nvim"}, opts = {ensure_installed = {"bashls", "clojure_lsp", "cssls", "jedi_language_server", "jsonls", "lua_ls", "eslint", "rust_analyzer", "solargraph", "fennel_language_server"}}, config = true}, {"neovim/nvim-lspconfig", dependencies = {"williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", "hrsh7th/cmp-nvim-lsp", "b0o/SchemaStore.nvim"}, config = lsp_config}, {"pmizio/typescript-tools.nvim", dependencies = {"neovim/nvim-lspconfig", "nvim-lua/plenary.nvim"}, opts = {}}, {"j-hui/fidget.nvim", dependencies = {"neovim/nvim-lspconfig"}, event = "LspAttach", opts = {notification = {window = {align = "top", y_padding = 2}}}}, {"SmiteshP/nvim-navic", opts = {depth_limit = 4, depth_limit_indicator = " [ \238\169\188 ] ", click = true, highlight = true, format_text = _6_, icons = cfg["navic-icons"], separator = " \238\170\182 ", safe_output = false}, config = true, dependencies = {"williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim"}}}
