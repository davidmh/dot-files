-- [nfnl] fnl/plugins/terminal.fnl
local core = require("nfnl.core")
local function _1_()
  local envrc = core.first(vim.fs.find({".envrc"}, {type = "file", limit = 1}))
  if envrc then
    return "direnv exec . zsh"
  else
    return vim.o.shell
  end
end
return {{"chomosuke/term-edit.nvim", ft = "toggleterm", version = "1.*", opts = {prompt_end = "\226\157\175 "}}, {"akinsho/toggleterm.nvim", branch = "main", dependencies = {"chomosuke/term-edit.nvim"}, opts = {shell = _1_, shade_terminals = false}}}
