-- [nfnl] fnl/plugins/direnv.fnl
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
return {"davidmh/direnv.nvim", branch = "custom-setup", opts = {async = true, get_cwd = get_cwd}}
