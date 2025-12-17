-- [nfnl] fnl/plugins/colorscheme.fnl
local _local_1_ = require("own.highlights")
local custom_highlights = _local_1_["custom-highlights"]
local _local_2_ = require("nfnl.module")
local autoload = _local_2_.autoload
local catppuccin = autoload("catppuccin")
local function _3_()
  local flavor = "mocha"
  catppuccin.setup({flavour = flavor, float = {solid = true}, term_colors = true, integrations = {which_key = true}, custom_highlights = custom_highlights, styles = {comments = {"italic"}}})
  return vim.cmd(table.concat({"Catppuccin", flavor}, " "))
end
return {"catppuccin/nvim", name = "catppuccin", config = _3_}
