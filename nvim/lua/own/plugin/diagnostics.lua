-- [nfnl] Compiled from fnl/own/plugin/diagnostics.fnl by https://github.com/Olical/nfnl, do not edit.
local core = require("nfnl.core")
local null_ls = require("null-ls")
local u = require("null-ls.utils")
local cspell = require("cspell")
local config = require("own.config")
local str = require("own.string")
local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics
local code_actions = null_ls.builtins.code_actions
local function root_pattern(pattern)
  local function _3_(_1_)
    local _arg_2_ = _1_
    local bufname = _arg_2_["bufname"]
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
local cspell_filetypes = {"css", "gitcommit", "clojure", "html", "javascript", "json", "less", "lua", "markdown", "python", "ruby", "typescript", "typescriptreact", "yaml"}
local function get_source_name(diagnostic)
  local function _5_()
    local _6_ = diagnostic.namespace
    if (nil ~= _6_) then
      local _7_ = vim.diagnostic.get_namespace(_6_)
      if (nil ~= _7_) then
        return (_7_).name
      else
        return _7_
      end
    else
      return _6_
    end
  end
  return (diagnostic.source or _5_() or ("ns:" .. tostring(diagnostic.namespace)))
end
local function diagnostic_format(diagnostic)
  return (config.icons[diagnostic.severity] .. " [" .. get_source_name(diagnostic) .. "] " .. diagnostic.message)
end
vim.diagnostic.config({underline = true, virtual_text = true, severity_sort = true, float = {header = "", border = config.border, format = diagnostic_format}, update_in_insert = false, signs = false})
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
  local _arg_13_ = _12_
  local cspell_config_path = _arg_13_["cspell_config_path"]
  return os.execute(str.format("jq -S '.words |= sort' ${path} > ${path}.tmp && mv ${path}.tmp ${path}", {path = cspell_config_path}))
end
local function on_add_to_dictionary(_14_)
  local _arg_15_ = _14_
  local dictionary_path = _arg_15_["dictionary_path"]
  return os.execute(str.format("sort ${path} -o ${path}", {path = dictionary_path}))
end
local cspell_config = {on_add_to_json = on_add_to_json, on_add_to_dictionary = on_add_to_dictionary}
local function _16_(_241)
  _241["severity"] = vim.diagnostic.severity.W
  return nil
end
return null_ls.setup({sources = {diagnostics.shellcheck, diagnostics.rubocop.with({cwd = root_pattern(".rubocop.yml"), command = "bundle", args = core.concat({"exec", "rubocop"}, diagnostics.rubocop._opts.args)}), diagnostics.luacheck.with({cwd = root_pattern(".luacheckrc"), condition = with_root_file(".luacheckrc")}), diagnostics.selene.with({cwd = root_pattern("selene.toml"), condition = with_root_file("selene.toml")}), cspell.diagnostics.with({cwd = root_pattern("cspell.json"), prefer_local = "node_modules/.bin", filetypes = cspell_filetypes, diagnostics_postprocess = _16_, config = cspell_config}), code_actions.shellcheck, cspell.code_actions.with({cwd = root_pattern("cspell.json"), prefer_local = "node_modules/.bin", filetypes = cspell_filetypes, config = cspell_config}), formatting.jq, formatting.rubocop.with({cwd = root_pattern(".rubocop.yml"), command = "bundle", args = core.concat({"exec", "rubocop"}, diagnostics.rubocop._opts.args)}), formatting.stylua, formatting.terraform_fmt, formatting.rustfmt}, on_attach = on_attach})
