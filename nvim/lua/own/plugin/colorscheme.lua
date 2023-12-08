-- [nfnl] Compiled from fnl/own/plugin/colorscheme.fnl by https://github.com/Olical/nfnl, do not edit.
local catppuccin = require("catppuccin")
local _local_1_ = require("own.plugin.highlights")
local custom_highlights = _local_1_["custom-highlights"]
catppuccin.setup({flavour = "macchiato", term_colors = true, integrations = {lsp_trouble = true, telescope = true, which_key = true}, custom_highlights = custom_highlights, transparent_background = false})
return vim.cmd.colorscheme("catppuccin")
