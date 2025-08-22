-- [nfnl] fnl/plugins/diagnostics.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local null_ls = autoload("null-ls")
local u = autoload("null-ls.utils")
local cfg = autoload("own.config")
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
local function get_source_name(diagnostic)
  local or_5_ = diagnostic.source
  if not or_5_ then
    local tmp_3_ = diagnostic.namespace
    if (nil ~= tmp_3_) then
      local tmp_3_0 = vim.diagnostic.get_namespace(tmp_3_)
      if (nil ~= tmp_3_0) then
        or_5_ = tmp_3_0.name
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
vim.diagnostic.config({underline = true, severity_sort = true, float = {format = diagnostic_format, header = {}}, signs = false, update_in_insert = false, virtual_lines = false, virtual_text = false})
vim.api.nvim_create_augroup("lsp-formatting", {clear = true})
local function on_attach(client, bufnr)
  if client:supports_method("textDocument/formatting") then
    local function _10_()
      return vim.lsp.buf.format({bufnr = bufnr})
    end
    return vim.api.nvim_create_autocmd("BufWritePre", {buffer = bufnr, callback = _10_, group = "lsp-formatting"})
  else
    return nil
  end
end
local function config()
  local formatting = null_ls.builtins.formatting
  local diagnostics = null_ls.builtins.diagnostics
  return null_ls.setup({sources = {diagnostics.selene.with({cwd = root_pattern("selene.toml"), condition = with_root_file("selene.toml")}), diagnostics.pylint.with({condition = with_root_file(".venv/bin/pylint"), prefer_local = ".venv/bin"}), diagnostics.mypy.with({condition = with_root_file("mypy.ini"), prefer_local = ".venv/bin"}), formatting.gofmt, diagnostics.sqlfluff.with({extra_args = {"--dialect", "postgres"}, prefer_local = ".venv/bin"}), formatting.sqlfluff.with({extra_args = {"--dialect", "postgres"}, prefer_local = ".venv/bin"}), formatting.stylua}, on_attach = on_attach})
end
return {"nvimtools/none-ls.nvim", dependencies = {"nvim-lua/plenary.nvim"}, config = config}
