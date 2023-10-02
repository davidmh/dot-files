-- [nfnl] Compiled from fnl/own/plugin/telescope.fnl by https://github.com/Olical/nfnl, do not edit.
local telescope = require("telescope")
telescope.setup({defaults = {layout_strategy = "horizontal", layout_config = {horizontal = {prompt_position = "top", preview_width = 0.55, results_width = 0.8}, vertical = {mirror = false}, width = 0.87, height = 0.8, preview_cutoff = 120}, sorting_strategy = "ascending", prompt_prefix = " \239\144\162  ", selection_caret = "\239\145\160 ", set_env = {COLORTERM = true}, vimgrep_arguments = {"ag", "--nocolor", "--vimgrep", "--smart-case"}, results_title = false}, pickers = {buffers = {sort_mru = true}}})
vim.keymap.set("n", "<M-x>", ":Telescope<CR>", {nowait = true})
return vim.keymap.set("n", "<D-x>", ":Telescope<CR>", {nowait = true})
