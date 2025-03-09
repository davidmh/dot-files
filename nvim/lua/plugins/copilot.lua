-- [nfnl] Compiled from fnl/plugins/copilot.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_()
  local path = vim.api.nvim_buf_get_name(0)
  return ((nil == string.match(path, ".*env.*")) and not vim.endswith(path, ".zprofile"))
end
return {"zbirenbaum/copilot.lua", event = "InsertEnter", opts = {suggestion = {enabled = true, auto_trigger = true, keymap = {next = "<m-n>", prev = "<m-p>", accept = "<m-y>", accept_word = "<m-w>", accept_line = "<m-l>", dismiss = "<m-[>"}}, panel = {enabled = true}, filetypes = {zsh = _1_, ["*"] = true}}}
