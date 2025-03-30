-- [nfnl] Compiled from fnl/plugins/diagnostics.fnl by https://github.com/Olical/nfnl, do not edit.
local core = require("nfnl.core")
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local null_ls = autoload("null-ls")
local u = autoload("null-ls.utils")
local cspell = autoload("cspell")
local cfg = autoload("own.config")
local str = autoload("own.string")
local function root_pattern(pattern)
  local function _3_(_2_)
    local bufname = _2_["bufname"]
    local root_fn = u.root_pattern(pattern)
    return root_fn(vim.fn.expand(bufname))
  end
  return _3_
end
local function with_root_file(...)
  local files = {...}
  local function _4_(utils)
    return utils.root_has_file(files)
  end
  return _4_
end
local cspell_filetypes = {"css", "clojure", "html", "javascript", "json", "less", "lua", "python", "ruby", "typescript", "typescriptreact", "yaml"}
local function get_source_name(diagnostic)
  local or_5_ = diagnostic.source
  if not or_5_ then
    local tmp_91_auto = diagnostic.namespace
    if (nil ~= tmp_91_auto) then
      local tmp_91_auto0 = vim.diagnostic.get_namespace(tmp_91_auto)
      if (nil ~= tmp_91_auto0) then
        or_5_ = tmp_91_auto0.name
      else
        or_5_ = nil
      end
    else
      or_5_ = nil
    end
  end
  return (or_5_ or ("ns:" .. tostring(diagnostic.namespace)))
end
local function diagnostic_format(diagnostic)
  return (cfg.icons[diagnostic.severity] .. " [" .. get_source_name(diagnostic) .. "] " .. diagnostic.message)
end
vim.diagnostic.config({underline = true, signs = {text = cfg.icons}, virtual_lines = {current_line = true}, severity_sort = true, float = {header = "", border = cfg.border, format = diagnostic_format}, update_in_insert = false, virtual_text = false})
vim.api.nvim_create_augroup("lsp-formatting", {clear = true})
local function on_attach(client, bufnr)
  if client.supports_method("textDocument/formatting") then
    local function _10_()
      return vim.lsp.buf.format({bufnr = bufnr})
    end
    return vim.api.nvim_create_autocmd("BufWritePre", {buffer = bufnr, callback = _10_, group = "lsp-formatting"})
  else
    return nil
  end
end
local function on_add_to_json(_12_)
  local cspell_config_path = _12_["cspell_config_path"]
  return os.execute(str.format("jq -S '.words |= sort' ${path} > ${path}.tmp && mv ${path}.tmp ${path}", {path = cspell_config_path}))
end
local function on_add_to_dictionary(_13_)
  local dictionary_path = _13_["dictionary_path"]
  return os.execute(str.format("sort ${path} -o ${path}", {path = dictionary_path}))
end
local cspell_config = {on_add_to_json = on_add_to_json, on_add_to_dictionary = on_add_to_dictionary, cspell_config_dirs = {"~/.config/cspell"}}
local function config()
  local formatting = null_ls.builtins.formatting
  local diagnostics = null_ls.builtins.diagnostics
  local function _14_(_241)
    _241["severity"] = vim.diagnostic.severity.W
    return nil
  end
  local function _15_(params)
    return core.concat({"run", "mypy"}, diagnostics.mypy._opts.args(params))
  end
  return null_ls.setup({sources = {diagnostics.selene.with({cwd = root_pattern("selene.toml"), condition = with_root_file("selene.toml")}), diagnostics.pylint.with({cwd = root_pattern("requirements-dev.txt"), condition = with_root_file("venv/bin/pylint"), prefer_local = ".venv/bin", args = {"--from-stdin", "$FILENAME", "-f", "json", "-d", "line-too-long,missing-function-docstring"}}), cspell.diagnostics.with({cwd = root_pattern("cspell.json"), prefer_local = "node_modules/.bin", filetypes = cspell_filetypes, diagnostics_postprocess = _14_, config = cspell_config}), cspell.code_actions.with({cwd = root_pattern("cspell.json"), prefer_local = "node_modules/.bin", filetypes = cspell_filetypes, config = cspell_config}), diagnostics.mypy.with({command = "uv", args = _15_, prefer_local = ".venv/bin"}), formatting.gofmt, diagnostics.sqlfluff.with({extra_args = {"--dialect", "postgres"}, prefer_local = ".venv/bin"}), formatting.sqlfluff.with({extra_args = {"--dialect", "postgres"}, prefer_local = ".venv/bin"}), formatting.stylua, formatting.terraform_fmt, formatting.nixpkgs_fmt}, on_attach = on_attach})
end
return {"nvimtools/none-ls.nvim", dependencies = {"nvim-lua/plenary.nvim", "davidmh/cspell.nvim"}, config = config}
