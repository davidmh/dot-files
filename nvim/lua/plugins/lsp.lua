-- [nfnl] fnl/plugins/lsp.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local core = autoload("nfnl.core")
local cfg = autoload("own.config")
local qf = autoload("own.quickfix")
local cmp_lsp = autoload("cmp_nvim_lsp")
local schema_store = autoload("schemastore")
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
local function lsp_config()
  local git_root = {".git"}
  local python_root = {"uv.lock", "venv/bin/python"}
  local client_capabilities = vim.lsp.protocol.make_client_capabilities()
  vim.lsp.config("*", {capabilities = cmp_lsp.default_capabilities(client_capabilities), init_options = {preferences = {includeCompletionsWithSnippetText = true, includeCompletionsForImportStatements = true}}})
  local server_configs
  local function _3_(config, root)
    local python_path = get_python_path(root)
    config["settings"] = {workspace = {environmentPath = python_path}}
    return nil
  end
  server_configs = {jsonls = {settings = {json = {schemas = schema_store.json.schemas(), validate = {enable = true}}}}, lua_ls = {settings = {Lua = {completion = {callSnippet = "Replace"}, diagnostics = {globals = {"vim"}}, format = {enable = false}, workspace = {checkThirdParty = false}}}}, eslint = {root_markers = git_root}, fennel_ls = {settings = {["fennel-ls"] = {["extra-globals"] = "vim", ["macro-path"] = (vim.fn.stdpath("config") .. "/fnl/own/macros.fnl")}}}, jedi_language_server = {on_new_config = _3_, root_markers = python_root}, ruff = {init_options = {settings = {lint = {enable = true, preview = true}}}}, harper_ls = {settings = {["harper-ls"] = {codeActions = {forceStable = true}}}}, gopls = {}, tflint = {}, terraformls = {}, typos_lsp = {}, yamlls = {}, nil_ls = {settings = {["nil"] = {formatting = {command = {"nixpkgs-fmt"}}}}}, air = {}, cssls = {root_markers = git_root}, bashls = {root_markers = git_root}, solargraph = {root_markers = git_root, cmd = {"direnv", "exec", ".", "solargraph", "stdio"}}}
  local server_names = core.keys(server_configs)
  for name, config in pairs(server_configs) do
    vim.lsp.config[name] = config
  end
  vim.lsp.enable(server_names)
  return nil
end
local function _4_(results, open_preview, jump_to_result)
  local _5_ = #results
  if (_5_ == 0) then
    return vim.notify("No results found")
  elseif (_5_ == 1) then
    jump_to_result(core.first(results))
    return vim.cmd({cmd = "normal"}, "args", {"zz"}, "bang", true)
  else
    local _ = _5_
    return open_preview(results)
  end
end
return {{"folke/lazydev.nvim", ft = "lua", opts = {library = {{path = "${3rd}/luv/library", words = {"vim%.uv"}}, "nvim-dap-ui"}}}, {"neovim/nvim-lspconfig", dependencies = {"b0o/SchemaStore.nvim", "folke/lazydev.nvim"}, config = lsp_config}, {"pmizio/typescript-tools.nvim", dependencies = {"nvim-lua/plenary.nvim"}, opts = {settings = {expose_as_code_action = {"add_missing_imports"}}, root_markers = {"tsconfig.json"}}}, {"j-hui/fidget.nvim", event = "LspAttach", opts = {notification = {window = {align = "top", y_padding = 2, winblend = 0}}}}, {"SmiteshP/nvim-navic", opts = {depth_limit = 4, depth_limit_indicator = " [ \238\169\188 ] ", click = true, highlight = true, icons = cfg["navic-icons"], separator = " \238\170\182 ", safe_output = false}}, {"dnlhc/glance.nvim", cmd = "Glance", opts = {mappings = {list = {["<m-p>"] = qf["glance/enter-preview"], ["<c-q>"] = qf["glance/enter-quickfix"], ["<c-n>"] = qf["glance/next-result"], ["<c-p>"] = qf["glance/previous-result"], ["<c-v>"] = qf["glance/vertical-split"], ["<c-x>"] = qf["glance/horizontal-split"]}, preview = {["<m-l>"] = qf["glance/enter-list"], ["<c-q>"] = qf["glance/enter-quickfix"], ["<c-n>"] = qf["glance/next-result"], ["<c-p>"] = qf["glance/previous-result"], ["<c-v>"] = qf["glance/vertical-split"], ["<c-x>"] = qf["glance/horizontal-split"]}}, hooks = {before_open = _4_}}}}
