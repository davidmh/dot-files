-- [nfnl] plugin/autocommands.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_.autoload
local projects = autoload("own.projects")
local navic = autoload("nvim-navic")
local function on_lsp_attach(args)
  local client = vim.lsp.get_client_by_id(args.data.client_id)
  if vim.tbl_contains({"eslint", "nil_ls", "solargraph", "terraformls", "air", "ruff", "rust-analyzer"}, client.name) then
    local function _2_()
      return vim.lsp.buf.format({id = client.id})
    end
    vim.api.nvim_create_autocmd("BufWritePre", {group = "own.autocommands", buffer = args.buf, callback = _2_})
  else
  end
  if client.server_capabilities.documentSymbolProvider then
    return navic.attach(client, args.buf)
  else
    return nil
  end
end
local group = vim.api.nvim_create_augroup("own.autocommands", {clear = true})
local function _5_()
  return projects.add()
end
vim.api.nvim_create_autocmd("User", {pattern = "RooterChDir", callback = _5_, group = group})
vim.api.nvim_create_autocmd("LspAttach", {callback = on_lsp_attach, group = group})
return nil
