-- [nfnl] Compiled from fnl/plugins/misc.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  vim.g.rooter_patterns = {".envrc", ".git", ".obsidian", ".rspec", "Cargo.toml", "lazy-lock.json", "pyproject.toml"}
  vim.g.rooter_silent_chdir = true
  return nil
end
local function _2_()
  vim.g.lt_location_list_toggle_map = "L"
  vim.g.lt_quickfix_list_toggle_map = "Q"
  return nil
end
return {{"airblade/vim-rooter", config = _1_}, {"Valloric/ListToggle", event = "VeryLazy", config = _2_}}
