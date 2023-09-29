-- [nfnl] Compiled from fnl/own/plugin/org.fnl by https://github.com/Olical/nfnl, do not edit.
local org_mode = require("orgmode")
local org_bullets = require("org-bullets")
org_mode.setup({org_agenda_files = {"~/Documents/org/*"}, org_default_notes_file = "~/Documents/org/refile.org", org_hide_emphasis_markers = true})
org_bullets.setup()
local function org_settings()
  vim.wo.conceallevel = 3
  vim.wo.foldenable = false
  return nil
end
local group = vim.api.nvim_create_augroup("org-settings", {clear = true})
vim.api.nvim_create_autocmd("BufRead", {pattern = "*.org", callback = org_settings, group = group})
return nil
