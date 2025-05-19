-- [nfnl] fnl/plugins/colorscheme.fnl
local _local_1_ = require("own.highlights")
local custom_highlights = _local_1_["custom-highlights"]
local _local_2_ = require("nfnl.module")
local autoload = _local_2_["autoload"]
local catppuccin = autoload("catppuccin")
local function _3_()
  local flavor = "latte"
  catppuccin.setup({flavour = flavor, term_colors = true, integrations = {which_key = true}, custom_highlights = custom_highlights, transparent_background = false})
  return vim.cmd(table.concat({"Catppuccin", flavor}, " "))
end
return {"catppuccin/nvim", name = "catppuccin", config = _3_}
