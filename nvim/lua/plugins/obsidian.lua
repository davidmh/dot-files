-- [nfnl] Compiled from fnl/plugins/obsidian.fnl by https://github.com/Olical/nfnl, do not edit.
local function keymap(_1_)
  local cmd = _1_["cmd"]
  local desc = _1_["desc"]
  local key = _1_["key"]
  return {("<leader>o" .. key), ("<cmd>" .. cmd .. "<cr>"), desc = desc}
end
return {"obsidian-nvim/obsidian.nvim", ft = {"markdown"}, dependencies = {"nvim-lua/plenary.nvim"}, keys = {keymap({key = "o", cmd = "ObsidianOpen", desc = "Open"}), keymap({key = "n", cmd = "ObsidianNew", desc = "New"}), keymap({key = "q", cmd = "ObsidianQuickSwitch", desc = "Quick Switch"}), keymap({key = "f", cmd = "ObsidianFollowLink", desc = "Follow Link"}), keymap({key = "b", cmd = "ObsidianBacklinks", desc = "Back links"}), keymap({key = "t", cmd = "ObsidianTags", desc = "Tags"}), keymap({key = ".", cmd = "ObsidianToday", desc = "Today"}), keymap({key = ",", cmd = "ObsidianYesterday", desc = "Yesterday"}), keymap({key = "/", cmd = "ObsidianTomorrow", desc = "Tomorrow"}), keymap({key = "d", cmd = "ObsidianDailies", desc = "Dailies"}), keymap({key = "s", cmd = "ObsidianSearch", desc = "Search"}), keymap({key = "l", cmd = "ObsidianLinks", desc = "Links"}), keymap({key = "e", cmd = "ObsidianExtractNote", desc = "Extract Note"}), keymap({key = "w", cmd = "ObsidianWorkspace", desc = "Workspace"}), keymap({key = "r", cmd = "ObsidianRename", desc = "Rename"})}, opts = {workspaces = {{name = "default", path = "~/Documents/Obsidian Vault/"}}, ui = {enable = false}, follow_url_func = vim.ui.open}}
