-- [nfnl] fnl/plugins/obsidian.fnl
local function keymap(_1_)
  local cmd = _1_["cmd"]
  local desc = _1_["desc"]
  local key = _1_["key"]
  return {("<leader>o" .. key), ("<cmd>" .. cmd .. "<cr>"), desc = desc}
end
return {"obsidian-nvim/obsidian.nvim", ft = {"markdown"}, dependencies = {"nvim-lua/plenary.nvim"}, keys = {{"<leader>o", "<ignore>", desc = "obsidian"}, keymap({key = "o", cmd = "ObsidianOpen", desc = "open"}), keymap({key = "n", cmd = "ObsidianNew", desc = "new"}), keymap({key = "q", cmd = "ObsidianQuickSwitch", desc = "quick switch"}), keymap({key = "f", cmd = "ObsidianFollowLink", desc = "follow link"}), keymap({key = "b", cmd = "ObsidianBacklinks", desc = "back links"}), keymap({key = "t", cmd = "ObsidianTags", desc = "tags"}), keymap({key = ".", cmd = "ObsidianToday", desc = "today"}), keymap({key = ",", cmd = "ObsidianYesterday", desc = "yesterday"}), keymap({key = "/", cmd = "ObsidianTomorrow", desc = "tomorrow"}), keymap({key = "d", cmd = "ObsidianDailies", desc = "dailies"}), keymap({key = "s", cmd = "ObsidianSearch", desc = "search"}), keymap({key = "l", cmd = "ObsidianLinks", desc = "links"}), keymap({key = "e", cmd = "ObsidianExtractNote", desc = "extract note"}), keymap({key = "w", cmd = "ObsidianWorkspace", desc = "workspace"}), keymap({key = "r", cmd = "ObsidianRename", desc = "rename"})}, opts = {completion = {nvim_cmp = true, min_chars = 2}, workspaces = {{name = "default", path = "~/Documents/Obsidian Vault/"}}, ui = {enable = false}, follow_url_func = vim.ui.open}}
