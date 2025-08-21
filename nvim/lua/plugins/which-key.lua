-- [nfnl] fnl/plugins/which-key.fnl
local _local_1_ = require("own.config")
local border = _local_1_["border"]
return {"folke/which-key.nvim", event = "VeryLazy", opts = {preset = "helix", win = {border = border}, show_help = false}}
