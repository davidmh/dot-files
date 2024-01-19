-- [nfnl] Compiled from fnl/plugins/diagnostics.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local core = autoload("nfnl.core")
local null_ls = autoload("null-ls")
local u = autoload("null-ls.utils")
local cspell = autoload("cspell")
local cfg = autoload("own.config")
local str = autoload("own.string")
local function root_pattern(pattern)
  local function _4_(_2_)
    local _arg_3_ = _2_
    local bufname = _arg_3_["bufname"]
    local root_fn = u.root_pattern(pattern)
    return root_fn(vim.fn.expand(bufname))
  end
  return _4_
end
local function with_root_file(...)
  local files = {...}
  local function _5_(utils)
    return utils.root_has_file(files)
  end
  return _5_
end
local cspell_filetypes = {"css", "gitcommit", "clojure", "html", "javascript", "json", "less", "lua", "markdown", "python", "ruby", "typescript", "typescriptreact", "yaml"}
local function get_source_name(diagnostic)
  local function _6_()
    local _7_ = diagnostic.namespace
    if (nil ~= _7_) then
      local _8_ = vim.diagnostic.get_namespace(_7_)
      if (nil ~= _8_) then
        return (_8_).name
      else
        return _8_
      end
    else
      return _7_
    end
  end
  return (diagnostic.source or _6_() or ("ns:" .. tostring(diagnostic.namespace)))
end
local function diagnostic_format(diagnostic)
  return (cfg.icons[diagnostic.severity] .. " [" .. get_source_name(diagnostic) .. "] " .. diagnostic.message)
end
vim.diagnostic.config({underline = true, virtual_text = true, severity_sort = true, float = {header = "", border = cfg.border, format = diagnostic_format}, signs = false, update_in_insert = false})
vim.api.nvim_create_augroup("lsp-formatting", {clear = true})
local function on_attach(client, bufnr)
  if client.supports_method("textDocument/formatting") then
    local function _11_()
      return vim.lsp.buf.format({bufnr = bufnr})
    end
    return vim.api.nvim_create_autocmd("BufWritePre", {buffer = bufnr, callback = _11_, group = "lsp-formatting"})
  else
    return nil
  end
end
local function on_add_to_json(_13_)
  local _arg_14_ = _13_
  local cspell_config_path = _arg_14_["cspell_config_path"]
  return os.execute(str.format("jq -S '.words |= sort' ${path} > ${path}.tmp && mv ${path}.tmp ${path}", {path = cspell_config_path}))
end
local function on_add_to_dictionary(_15_)
  local _arg_16_ = _15_
  local dictionary_path = _arg_16_["dictionary_path"]
  return os.execute(str.format("sort ${path} -o ${path}", {path = dictionary_path}))
end
local cspell_config = {on_add_to_json = on_add_to_json, on_add_to_dictionary = on_add_to_dictionary, read_config_synchronously = false}
local function config()
  local formatting = null_ls.builtins.formatting
  local diagnostics = null_ls.builtins.diagnostics
  local code_actions = null_ls.builtins.code_actions
  local function _17_(_241)
    _241["severity"] = vim.diagnostic.severity.W
    return nil
  end
  return null_ls.setup({sources = {diagnostics.shellcheck, diagnostics.rubocop.with({cwd = root_pattern(".rubocop.yml"), command = "bundle", args = core.concat({"exec", "rubocop"}, diagnostics.rubocop._opts.args)}), diagnostics.luacheck.with({cwd = root_pattern(".luacheckrc"), condition = with_root_file(".luacheckrc")}), diagnostics.selene.with({cwd = root_pattern("selene.toml"), condition = with_root_file("selene.toml")}), cspell.diagnostics.with({cwd = root_pattern("cspell.json"), prefer_local = "node_modules/.bin", filetypes = cspell_filetypes, diagnostics_postprocess = _17_, config = cspell_config}), code_actions.shellcheck, cspell.code_actions.with({cwd = root_pattern("cspell.json"), prefer_local = "node_modules/.bin", filetypes = cspell_filetypes, config = cspell_config}), formatting.gofmt, formatting.jq, formatting.rubocop.with({cwd = root_pattern(".rubocop.yml"), command = "bundle", args = core.concat({"exec", "rubocop"}, diagnostics.rubocop._opts.args)}), formatting.stylua, formatting.terraform_fmt, formatting.rustfmt}, on_attach = on_attach})
end
return {{"folke/trouble.nvim", dependencies = {"nvim-tree/nvim-web-devicons"}, opts = {icons = true, signs = {error = cfg.icons.ERROR, warning = cfg.icons.WARN, hint = cfg.icons.HINT, information = cfg.icons.INFO, other = "\239\171\160"}, padding = false, group = false}, config = true}, {"nvimtools/none-ls.nvim", dependencies = {"nvim-lua/plenary.nvim", "davidmh/cspell.nvim"}, config = config}}
