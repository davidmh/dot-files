-- [nfnl] init.fnl
local _local_1_ = require("own.config")
local border = _local_1_["border"]
require("own.default-plugins")
require("own.bootstrap")
require("own.options")
local lazy = require("lazy")
return lazy.setup("plugins", {dev = {path = (vim.env.HOME .. "/Projects"), fallback = true}, checker = {enabled = true, notify = false}, ui = {border = border, backdrop = 100}, rocks = {hererocks = true}})
