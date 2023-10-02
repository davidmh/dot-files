-- [nfnl] Compiled from after/ftplugin/qf.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local _local_2_ = autoload("own.helpers")
local get_largest_window_id = _local_2_["get-largest-window-id"]
local function on_alternative_open(direction)
  local function _3_()
    local _let_4_ = vim.fn.getqflist()[vim.fn.line(".")]
    local bufnr = _let_4_["bufnr"]
    local lnum = _let_4_["lnum"]
    local col = _let_4_["col"]
    vim.fn.win_gotoid(get_largest_window_id())
    vim.cmd((direction .. " " .. vim.api.nvim_buf_get_name(bufnr)))
    return vim.fn.cursor(lnum, col)
  end
  return _3_
end
local opts = {buffer = 0, silent = true, nowait = true}
vim.keymap.set("n", "<c-v>", on_alternative_open("vsplit"), opts)
vim.keymap.set("n", "<c-x>", on_alternative_open("split"), opts)
vim.keymap.set("n", "<", ":silent colder<cr>", opts)
return vim.keymap.set("n", ">", ":silent cnewer<cr>", opts)
