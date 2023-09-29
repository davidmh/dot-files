-- [nfnl] Compiled from fnl/own/plugin/flatten.fnl by https://github.com/Olical/nfnl, do not edit.
local flatten = require("flatten")
local diff_mode
local function _1_(_241)
  return vim.tbl_contains((_241 or {}), "-d")
end
diff_mode = _1_
return flatten.setup({window = {open = "smart"}, callbacks = {should_block = diff_mode}, nest_if_no_args = true})
