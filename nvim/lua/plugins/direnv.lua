-- [nfnl] fnl/plugins/direnv.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local direnv_opts = autoload("direnv-nvim.opts")
local git_filetypes = {"git", "fugitive", "fugitiveblame", "NeogitStatus"}
local function get_basename()
  return vim.fs.basename(vim.api.nvim_buf_get_name(0))
end
local function get_cwd()
  if (vim.tbl_contains(git_filetypes, vim.o.ft) or vim.tbl_contains(git_filetypes, get_basename())) then
    return vim.fs.root(vim.uv.cwd(), ".git")
  else
    return direnv_opts.buffer_setup.get_cwd()
  end
end
return {"davidmh/direnv.nvim", branch = "custom-setup", opts = {async = true, type = "custom", custom_setup = {get_cwd = get_cwd}}}
