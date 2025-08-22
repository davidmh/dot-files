-- [nfnl] fnl/plugins/rooter.fnl
local function _1_()
  vim.g.rooter_patterns = {".git", ".obsidian", "Gemfile", "package.json", "Cargo.toml", "pyproject.toml", "lazy-lock.json"}
  vim.g.rooter_silent_chdir = true
  return nil
end
return {{"airblade/vim-rooter", config = _1_}}
