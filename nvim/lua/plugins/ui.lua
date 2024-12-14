-- [nfnl] Compiled from fnl/plugins/ui.fnl by https://github.com/Olical/nfnl, do not edit.
local function _1_(_241, _242)
  return math.min(_242, 80)
end
local function _2_(_241, _242)
  return math.min(_242, 15)
end
return {{"nvim-tree/nvim-web-devicons", config = true}, {"nvim-zh/colorful-winsep.nvim", config = true, event = "VeryLazy"}, {"stevearc/dressing.nvim", event = "VeryLazy", opts = {select = {backend = "telescope"}, telescope = {layout_config = {width = _1_, height = _2_}}}}}
