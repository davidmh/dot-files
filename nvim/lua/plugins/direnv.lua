-- [nfnl] fnl/plugins/direnv.fnl
local core = require("nfnl.core")
local git_filetypes = {"git", "fugitive", "fugitiveblame", "NeogitStatus", "NeogitCommitPopup"}
local function get_cwd()
  local buf_name = vim.api.nvim_buf_get_name(0)
  if (vim.tbl_contains(git_filetypes, vim.o.ft) or vim.tbl_contains(git_filetypes, vim.fs.basename(buf_name))) then
    return vim.fs.root(vim.uv.cwd(), ".git")
  else
    if vim.uv.fs_stat(buf_name) then
      return vim.fs.dirname(buf_name)
    else
      return nil
    end
  end
end
local function on_direnv_finished(evt)
  if (evt.filetype == "ruby") then
    return vim.lsp.start({name = "solargraph", cmd = {"bundle", "exec", "solargraph", "stdio"}}, {bufnr = evt.buffer})
  else
    return nil
  end
end
return {"actionshrimp/direnv.nvim", opts = {async = true, get_cwd = get_cwd, on_direnv_finished = on_direnv_finished}}
