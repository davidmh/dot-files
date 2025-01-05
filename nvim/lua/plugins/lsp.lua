-- [nfnl] Compiled from fnl/plugins/lsp.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local core = autoload("nfnl.core")
local cfg = autoload("own.config")
local util = autoload("lspconfig.util")
local cmp = autoload("blink.cmp")
local schema_store = autoload("schemastore")
local lspconfig = autoload("lspconfig")
local mason = autoload("mason")
local mason_registry = autoload("mason-registry")
local mason_lspconfig = autoload("mason-lspconfig")
local glance = autoload("glance")
local function on_linter_install(pkg)
  local function _2_()
    return vim.notify((pkg.name .. " installed"), vim.log.levels.INFO, {title = "mason.nvim"})
  end
  return vim.defer_fn(_2_, 100)
end
local ensure_linters = {"cspell", "luacheck", "stylua"}
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
local function ruby_lsps()
  lspconfig.solargraph.setup({root_dir = util.root_pattern(".git"), cmd = {"bundle", "exec", "solargraph", "stdio"}})
  local function _5_()
    return vim.lsp.buf.format()
  end
  return vim.api.nvim_create_autocmd("BufWritePre", {pattern = "*.rb", callback = _5_})
end
local function lsp_config()
  local git_root = util.root_pattern(".git")
  local deno_root = util.root_pattern("deno.json", "deno.jsonc")
  local tailwind_root = util.root_pattern("tailwind.config.ts")
  local base_settings = {capabilities = cmp.get_lsp_capabilities(), init_options = {preferences = {includeCompletionsWithSnippetText = true, includeCompletionsForImportStatements = true}}}
  local server_configs = {jsonls = {settings = {json = {schemas = schema_store.json.schemas(), validate = {enable = true}}}}, lua_ls = {settings = {Lua = {completion = {callSnippet = "Replace"}, diagnostics = {globals = {"vim", "it", "describe", "before_each", "after_each", "pending"}}, format = {enable = false}, workspace = {checkThirdParty = false}}}}, eslint = {root_dir = git_root}, fennel_language_server = {single_file_support = true, root_dir = lspconfig.util.root_pattern("fnl"), settings = {fennel = {diagnostics = {globals = {"vim", "jit", "comment", "love"}}, workspace = {library = vim.api.nvim_list_runtime_paths(), checkThirdParty = false}}}}, harper_ls = {settings = {["harper-ls"] = {codeActions = {forceStable = true}}}, filetypes = {"markdown", "gitcommit", "text"}}, cssls = {root_dir = git_root}, shellcheck = {root_dir = git_root}, tailwindcss = {root_dir = tailwind_root}}
  for _, server_name in ipairs(mason_lspconfig.get_installed_servers()) do
    local server_setup = core["get-in"](lspconfig, {server_name, "setup"})
    local server_config = core.get(server_configs, server_name, {})
    if (server_name == "gopls") then
      server_setup(server_config)
    else
      server_setup(core.merge(base_settings, server_config))
    end
  end
  ruby_lsps()
  lspconfig.denols.setup({root_dir = deno_root})
  return nil
end
local function glance_config()
  local enter_quickfix
  local function _7_()
    return glance.actions.quickfix()
  end
  enter_quickfix = _7_
  local enter_preview
  local function _8_()
    return glance.actions.enter_win("preview")
  end
  enter_preview = _8_
  local enter_list
  local function _9_()
    return glance.actions.enter_win("list")
  end
  enter_list = _9_
  local next_result
  local function _10_()
    return glance.actions.next_location()
  end
  next_result = _10_
  local previous_result
  local function _11_()
    return glance.actions.previous_location()
  end
  previous_result = _11_
  local vertical_split
  local function _12_()
    return glance.actions.jump_vsplit()
  end
  vertical_split = _12_
  local horizontal_split
  local function _13_()
    return glance.actions.jump_split()
  end
  horizontal_split = _13_
  local function _14_(results, open_preview, jump_to_result)
    if (#results == 1) then
      jump_to_result(core.first(results))
      return vim.cmd("normal zz")
    else
      return open_preview(results)
    end
  end
  return glance.setup({mappings = {list = {["<m-p>"] = enter_preview, ["<c-q>"] = enter_quickfix, ["<c-n>"] = next_result, ["<c-p>"] = previous_result, ["<c-v>"] = vertical_split, ["<c-x>"] = horizontal_split}, preview = {["<m-l>"] = enter_list, ["<c-q>"] = enter_quickfix, ["<c-n>"] = next_result, ["<c-p>"] = previous_result, ["<c-v>"] = vertical_split, ["<c-x>"] = horizontal_split}}, hooks = {before_open = _14_}})
end
local function _16_(file_name)
  local deno_root = util.root_pattern("deno.json", "deno.jsonc")
  local ts_root = util.root_pattern("tsconfig.json")
  return ((deno_root(file_name) == nil) and ts_root(file_name))
end
local function _17_(text)
  if (text:match("^it%(") or text:match("^describe%(")) then
    return text:gsub("^it%('", "it "):gsub("^describe%('", "describe "):gsub("'%) callback$", "")
  else
    return text:gsub(" callback$", "")
  end
end
return {{"folke/lazydev.nvim", ft = "lua", opts = {library = {"luvit-meta/library"}}, config = true}, {"Bilal2453/luvit-meta", lazy = true}, {"williamboman/mason.nvim", config = mason_config}, {"williamboman/mason-lspconfig.nvim", dependencies = {"williamboman/mason.nvim"}, opts = {ensure_installed = {"bashls", "clojure_lsp", "cssls", "jdtls", "jedi_language_server", "jsonls", "lua_ls", "eslint", "fennel_language_server", "harper_ls", "tailwindcss"}}, config = true}, {"neovim/nvim-lspconfig", dependencies = {"williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", "Saghen/blink.cmp", "b0o/SchemaStore.nvim"}, config = lsp_config}, {"pmizio/typescript-tools.nvim", dependencies = {"neovim/nvim-lspconfig", "nvim-lua/plenary.nvim"}, opts = {settings = {expose_as_code_action = {"add_missing_imports"}}, root_dir = _16_}}, {"j-hui/fidget.nvim", dependencies = {"neovim/nvim-lspconfig"}, event = "LspAttach", opts = {notification = {window = {align = "top", y_padding = 2}}}}, {"SmiteshP/nvim-navic", opts = {depth_limit = 4, depth_limit_indicator = " [ \238\169\188 ] ", click = true, highlight = true, format_text = _17_, icons = cfg["navic-icons"], separator = " \238\170\182 ", safe_output = false}, config = true, dependencies = {"williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim"}}, {"dnlhc/glance.nvim", cmd = "Glance", config = glance_config}}
