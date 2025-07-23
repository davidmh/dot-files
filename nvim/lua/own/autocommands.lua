-- [nfnl] fnl/own/autocommands.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local projects = autoload("own.projects")
local navic = autoload("nvim-navic")
local function on_lsp_attach(args)
  local client = vim.lsp.get_client_by_id(args.data.client_id)
  if (client.name == "eslint") then
    vim.api.nvim_create_autocmd("BufWritePre", {group = "own.autocommands", buffer = args.buf, command = "EslintFixAll"})
  else
  end
  if vim.tbl_contains({"nil_ls", "solargraph", "terraformls", "air"}, client.name) then
    local function _3_()
      return vim.lsp.buf.format({id = client.id})
    end
    vim.api.nvim_create_autocmd("BufWritePre", {group = "own.autocommands", buffer = args.buf, callback = _3_})
  else
  end
  if client.server_capabilities.documentSymbolProvider then
    return navic.attach(client, args.buf)
  else
    return nil
  end
end
local group = vim.api.nvim_create_augroup("own.autocommands", {clear = true})
local function _6_()
  return projects.add()
end
vim.api.nvim_create_autocmd("User", {pattern = "RooterChDir", callback = _6_, group = group})
vim.api.nvim_create_autocmd("LspAttach", {callback = on_lsp_attach, group = group})
return nil
