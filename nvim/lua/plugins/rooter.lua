-- [nfnl] fnl/plugins/rooter.fnl
local function _1_()
  vim.g.rooter_patterns = {".envrc", ".git", ".obsidian", ".rspec", "Cargo.toml", "lazy-lock.json", "yarn.lock", "pyproject.toml"}
  vim.g.rooter_silent_chdir = true
  return nil
end
return {{"airblade/vim-rooter", config = _1_}}
