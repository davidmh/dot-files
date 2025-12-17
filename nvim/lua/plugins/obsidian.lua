-- [nfnl] fnl/plugins/obsidian.fnl
local function keymap(_1_)
  local cmd = _1_.cmd
  local desc = _1_.desc
  local key = _1_.key
  return {("<leader>o" .. key), ("<cmd>" .. cmd .. "<cr>"), desc = desc}
end
return {"obsidian-nvim/obsidian.nvim", ft = {"markdown"}, dependencies = {"nvim-lua/plenary.nvim"}, keys = {{"<leader>o", "<ignore>", desc = "obsidian"}, keymap({key = "o", cmd = "Obsidian open", desc = "open"}), keymap({key = "n", cmd = "Obsidian new", desc = "new"}), keymap({key = "q", cmd = "Obsidian quickSwitch", desc = "quick switch"}), keymap({key = "f", cmd = "Obsidian followLink", desc = "follow link"}), keymap({key = "b", cmd = "Obsidian backlinks", desc = "back links"}), keymap({key = "t", cmd = "Obsidian tags", desc = "tags"}), keymap({key = ".", cmd = "Obsidian today", desc = "today"}), keymap({key = ",", cmd = "Obsidian yesterday", desc = "yesterday"}), keymap({key = "/", cmd = "Obsidian tomorrow", desc = "tomorrow"}), keymap({key = "d", cmd = "Obsidian dailies", desc = "dailies"}), keymap({key = "s", cmd = "Obsidian search", desc = "search"}), keymap({key = "l", cmd = "Obsidian links", desc = "links"}), keymap({key = "e", cmd = "Obsidian extractNote", desc = "extract note"}), keymap({key = "w", cmd = "Obsidian workspace", desc = "workspace"}), keymap({key = "r", cmd = "Obsidian rename", desc = "rename"})}, opts = {completion = {nvim_cmp = true, min_chars = 2}, workspaces = {{name = "default", path = "~/Documents/Obsidian Vault/"}}, ui = {enable = true}, follow_url_func = vim.ui.open, statusline = {enabled = false}, legacy_commands = false}}
