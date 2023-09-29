-- [nfnl] Compiled from fnl/own/plugin/copilot.fnl by https://github.com/Olical/nfnl, do not edit.
local copilot = require("copilot")
local copilot_panel = require("copilot.panel")
local function _1_()
  return (nil == string.match(vim.api.nvim_buf_get_name(0), ".*env.*"))
end
return copilot.setup({suggestion = {enabled = true, auto_trigger = true, keymap = {next = "<m-n>", prev = "<m-p>", accept = "<m-y>", accept_word = "<m-w>", accept_line = "<m-l>", dismiss = "<m-[>"}}, panel = {enabled = true}, filetypes = {javascript = true, typescript = true, typescriptreact = true, toggleterm = true, fennel = true, less = true, lua = true, python = true, ruby = true, rust = true, zsh = _1_, sh = true, ["*"] = false}})
