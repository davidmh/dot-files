-- [nfnl] Compiled from fnl/own/bootstrap.fnl by https://github.com/Olical/nfnl, do not edit.
local data_path = vim.fn.stdpath("data")
local function ensure(user, repo, alias)
  local install_path = string.format("%s/lazy/%s", data_path, (alias or repo))
  local repo_url = string.format("https://github.com/%s/%s", user, repo)
  if (vim.fn.empty(vim.fn.glob(install_path)) > 0) then
    vim.fn.system({"git", "clone", "--filter=blob:none", "--single-branch", repo_url, install_path})
  else
  end
  return (vim.opt.runtimepath):prepend(install_path)
end
ensure("folke", "lazy.nvim")
ensure("Olical", "nfnl")
return ensure("catppuccin", "nvim", "catppuccin")
