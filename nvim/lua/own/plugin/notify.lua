-- [nfnl] Compiled from fnl/own/plugin/notify.fnl by https://github.com/Olical/nfnl, do not edit.
local telescope = require("telescope")
local notify = require("notify")
notify.setup({timeout = 2500, minimum_width = 30, fps = 60, top_down = false})
vim.notify = notify
return telescope.load_extension("notify")
