-- [nfnl] Compiled from fnl/own/plugin/telescope.fnl by https://github.com/Olical/nfnl, do not edit.
local telescope = require("telescope")
telescope.setup({defaults = {layout_strategy = "horizontal", layout_config = {horizontal = {prompt_position = "top", preview_width = 0.55, results_width = 0.8}, vertical = {mirror = false}, width = 0.87, height = 0.8, preview_cutoff = 120}, sorting_strategy = "ascending", prompt_prefix = " \239\144\162  ", selection_caret = "\239\145\160 ", set_env = {COLORTERM = true}, vimgrep_arguments = {"ag", "--nocolor", "--vimgrep", "--smart-case"}, results_title = false}, pickers = {buffers = {sort_mru = true}}})
do
  local opts_1_auto
  do
    local tbl_14_auto = {}
    for k_2_auto, v_3_auto in pairs(({nowait = true} or {})) do
      local k_15_auto, v_16_auto = k_2_auto, v_3_auto
      if ((k_15_auto ~= nil) and (v_16_auto ~= nil)) then
        tbl_14_auto[k_15_auto] = v_16_auto
      else
      end
    end
    opts_1_auto = tbl_14_auto
  end
  if (opts_1_auto.noremap == nil) then
    opts_1_auto.noremap = true
  else
  end
  if (opts_1_auto.silent == nil) then
    opts_1_auto.silent = true
  else
  end
  vim.keymap.set("n", "<M-x>", ":Telescope<CR>", opts_1_auto)
end
local opts_1_auto
do
  local tbl_14_auto = {}
  for k_2_auto, v_3_auto in pairs(({nowait = true} or {})) do
    local k_15_auto, v_16_auto = k_2_auto, v_3_auto
    if ((k_15_auto ~= nil) and (v_16_auto ~= nil)) then
      tbl_14_auto[k_15_auto] = v_16_auto
    else
    end
  end
  opts_1_auto = tbl_14_auto
end
if (opts_1_auto.noremap == nil) then
  opts_1_auto.noremap = true
else
end
if (opts_1_auto.silent == nil) then
  opts_1_auto.silent = true
else
end
return vim.keymap.set("n", "<D-x>", ":Telescope<CR>", opts_1_auto)
