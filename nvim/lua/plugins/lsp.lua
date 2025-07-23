-- [nfnl] fnl/plugins/lsp.fnl
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
local glance = autoload("glance")
local function on_linter_install(pkg)
  local function _2_()
    return vim.notify((pkg.name .. " installed"), vim.log.levels.INFO, {title = "mason.nvim"})
  end
  return vim.defer_fn(_2_, 100)
end
local function executable_3f(path)
  if (vim.fn.executable(path) == 1) then
    return path
  else
    return nil
  end
end
local function get_python_path(workspace)
  return (executable_3f((workspace .. "/.devenv/state/venv/bin/python")) or executable_3f((workspace .. "/.venv/bin/python")) or executable_3f((workspace .. "/venv/bin/python")) or vim.fn.exepath("python3") or vim.fn.exepath("python") or "python")
end
local ensure_linters = {"luacheck", "stylua"}
local function mason_config()
  mason.setup({ui = {border = cfg.border}})
  mason_registry:on("package:install:success", on_linter_install)
  local function _4_()
    for _, name in ipairs(ensure_linters) do
      local pkg = mason_registry.get_package(name)
      if not pkg:is_installed() then
        pkg:install()
      else
      end
    end
    return nil
  end
  return vim.defer_fn(_4_, 100)
end
local function lsp_config()
  local git_root = util.root_pattern(".git")
  local deno_root = util.root_pattern("deno.json", "deno.jsonc")
  local python_root = util.root_pattern("uv.lock", "venv/bin/python")
  local client_capabilities = vim.lsp.protocol.make_client_capabilities()
  vim.lsp.config("*", {capabilities = cmp_lsp.default_capabilities(client_capabilities), init_options = {preferences = {includeCompletionsWithSnippetText = true, includeCompletionsForImportStatements = true}}})
  local server_configs
  local function _6_(config, root)
    local python_path = get_python_path(root)
    config["settings"] = {workspace = {environmentPath = python_path}}
    return nil
  end
  server_configs = {jsonls = {settings = {json = {schemas = schema_store.json.schemas(), validate = {enable = true}}}}, lua_ls = {settings = {Lua = {completion = {callSnippet = "Replace"}, diagnostics = {globals = {"vim"}}, format = {enable = false}, workspace = {checkThirdParty = false}}}}, eslint = {root_dir = git_root}, jedi_language_server = {on_new_config = _6_, root_dir = python_root}, ruff = {init_options = {settings = {lint = {enable = true, preview = true}}}}, harper_ls = {settings = {["harper-ls"] = {codeActions = {forceStable = true}}}}, gopls = {}, tflint = {}, terraformls = {}, typos_lsp = {}, yamlls = {}, nil_ls = {settings = {["nil"] = {formatting = {command = {"nixpkgs-fmt"}}}}}, air = {}, cssls = {root_dir = git_root}, bashls = {root_dir = git_root}, solargraph = {root_dir = git_root, cmd = {"direnv", "exec", ".", "solargraph", "stdio"}}, denols = {root_dir = deno_root}}
  for _, server_name in ipairs(core.keys(server_configs)) do
    local server_setup = core["get-in"](lspconfig, {server_name, "setup"})
    local server_config = core.get(server_configs, server_name, {})
    server_setup(server_config)
  end
  return nil
end
local function enter_quickfix()
  return glance.actions.quickfix()
end
local function enter_preview()
  return glance.actions.enter_win("preview")
end
local function enter_list()
  return glance.actions.enter_win("list")
end
local function next_result()
  return glance.actions.next_location()
end
local function previous_result()
  return glance.actions.previous_location()
end
local function vertical_split()
  return glance.actions.jump_vsplit()
end
local function horizontal_split()
  return glance.actions.jump_split()
end
local function _7_(file_name)
  local deno_root = util.root_pattern("deno.json", "deno.jsonc")
  local ts_root = util.root_pattern("tsconfig.json")
  return ((deno_root(file_name) == nil) and ts_root(file_name))
end
local function _8_(text)
  if (text:match("^it%(") or text:match("^describe%(")) then
    return text:gsub("^it%('", "it "):gsub("^describe%('", "describe "):gsub("'%) callback$", "")
  else
    return text:gsub(" callback$", "")
  end
end
local function _10_(results, open_preview, jump_to_result)
  local _11_ = #results
  if (_11_ == 0) then
    return vim.notify("No results found")
  elseif (_11_ == 1) then
    jump_to_result(core.first(results))
    return vim.cmd({cmd = "normal"}, "args", {"zz"}, "bang", true)
  else
    local _ = _11_
    return open_preview(results)
  end
end
return {{"folke/lazydev.nvim", ft = "lua", opts = {library = {{path = "${3rd}/luv/library", words = {"vim%.uv"}}, "nvim-dap-ui"}}}, {"williamboman/mason.nvim", config = mason_config}, {"williamboman/mason-lspconfig.nvim", dependencies = {"williamboman/mason.nvim"}, opts = {ensure_installed = {"bashls", "clojure_lsp", "cssls", "jdtls", "jedi_language_server", "ruff", "jsonls", "lua_ls", "eslint", "fennel_language_server", "harper_ls", "typos_lsp", "tflint", "terraformls", "yamlls", "nil_ls", "air"}, automatic_enable = false}}, {"neovim/nvim-lspconfig", dependencies = {"williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", "b0o/SchemaStore.nvim", "folke/lazydev.nvim"}, config = lsp_config}, {"pmizio/typescript-tools.nvim", dependencies = {"neovim/nvim-lspconfig", "nvim-lua/plenary.nvim"}, opts = {settings = {expose_as_code_action = {"add_missing_imports"}}, root_dir = _7_}}, {"j-hui/fidget.nvim", dependencies = {"neovim/nvim-lspconfig"}, event = "LspAttach", opts = {notification = {window = {align = "top", y_padding = 2, winblend = 0}}}}, {"SmiteshP/nvim-navic", opts = {depth_limit = 4, depth_limit_indicator = " [ \238\169\188 ] ", click = true, highlight = true, format_text = _8_, icons = cfg["navic-icons"], separator = " \238\170\182 ", safe_output = false}, config = true, dependencies = {"williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim"}}, {"dnlhc/glance.nvim", cmd = "Glance", opts = {mappings = {list = {["<m-p>"] = enter_preview, ["<c-q>"] = enter_quickfix, ["<c-n>"] = next_result, ["<c-p>"] = previous_result, ["<c-v>"] = vertical_split, ["<c-x>"] = horizontal_split}, preview = {["<m-l>"] = enter_list, ["<c-q>"] = enter_quickfix, ["<c-n>"] = next_result, ["<c-p>"] = previous_result, ["<c-v>"] = vertical_split, ["<c-x>"] = horizontal_split}}, hooks = {before_open = _10_}}}}
