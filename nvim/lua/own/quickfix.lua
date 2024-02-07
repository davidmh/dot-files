-- [nfnl] Compiled from fnl/own/quickfix.fnl by https://github.com/Olical/nfnl, do not edit.
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
local previous_qf_stack_entry_key = "<"
local next_qf_stack_entry_key = ">"
local function set_quickfix_mappings()
  local opts = {buffer = 0, silent = true, nowait = true}
  vim.keymap.set("n", "<c-v>", on_alternative_open("vsplit"), opts)
  vim.keymap.set("n", "<c-x>", on_alternative_open("split"), opts)
  vim.keymap.set("n", previous_qf_stack_entry_key, ":silent colder<cr>", opts)
  return vim.keymap.set("n", next_qf_stack_entry_key, ":silent cnewer<cr>", opts)
end
local function get_quickfix_title()
  return (vim.fn.getqflist({title = 1})).title
end
local function get_quickfix_history_size()
  return (vim.fn.getqflist({nr = "$"})).nr
end
local function get_quickfix_current_index()
  return (vim.fn.getqflist({nr = 0})).nr
end
local function show_quickfix_title_3f()
  return ((vim.o.filetype == "qf") and ("" ~= get_quickfix_title()))
end
local quickfix_history_status_component
local function _5_()
  local _6_
  if (get_quickfix_current_index() > 1) then
    _6_ = "lavender"
  else
    _6_ = "surface1"
  end
  return {fg = _6_}
end
local function _8_()
  return (get_quickfix_current_index() .. "/" .. get_quickfix_history_size())
end
local function _9_()
  local _10_
  if (get_quickfix_current_index() < get_quickfix_history_size()) then
    _10_ = "lavender"
  else
    _10_ = "surface1"
  end
  return {fg = _10_}
end
local function _12_()
  return (show_quickfix_title_3f() and (get_quickfix_history_size() > 1))
end
quickfix_history_status_component = {{provider = (" " .. previous_qf_stack_entry_key .. " "), hl = _5_}, {provider = _8_, hl = {fg = "lavender"}}, {provider = (" " .. next_qf_stack_entry_key .. " "), hl = _9_}, condition = _12_}
return {["set-quickfix-mappings"] = set_quickfix_mappings, ["get-quickfix-title"] = get_quickfix_title, ["show-quickfix-title?"] = show_quickfix_title_3f, ["quickfix-history-status-component"] = quickfix_history_status_component}
