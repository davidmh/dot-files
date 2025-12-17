-- [nfnl] fnl/plugins/conjure.fnl
local _local_1_ = require("own.config")
local border = _local_1_.border
vim.g["conjure#log#hud#border"] = border
vim.g["conjure#client#fennel#aniseed#deprecation_warning"] = false
vim.g["conjure#filetypes"] = {"fennel", "clojure"}
return {"Olical/conjure", branch = "main"}
