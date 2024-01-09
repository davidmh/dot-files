-- [nfnl] Compiled from fnl/plugins/colorscheme.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("own.highlights")
local custom_highlights = _local_1_["custom-highlights"]
local _local_2_ = require("nfnl.module")
local autoload = _local_2_["autoload"]
local catppuccin = autoload("catppuccin")
local function _3_()
  catppuccin.setup({flavour = "mocha", term_colors = true, integrations = {lsp_trouble = true, telescope = true, which_key = true}, custom_highlights = custom_highlights, transparent_background = false})
  return vim.cmd.colorscheme("catppuccin-mocha")
end
return {"catppuccin/nvim", name = "catppuccin", config = _3_}
