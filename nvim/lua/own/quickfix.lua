-- [nfnl] fnl/own/quickfix.fnl
local _local_1_ = require("nfnl.module")
local define = _local_1_.define
local _local_2_ = require("own.helpers")
local get_largest_window_id = _local_2_["get-largest-window-id"]
local M = define("own.quickfix")
local function on_alternative_open(direction)
  local function _3_()
    local _let_4_ = vim.fn.getqflist()[vim.fn.line(".")]
    local bufnr = _let_4_.bufnr
    local lnum = _let_4_.lnum
    local col = _let_4_.col
    vim.fn.win_gotoid(get_largest_window_id())
    vim.cmd((direction .. " " .. vim.api.nvim_buf_get_name(bufnr)))
    return vim.fn.cursor(lnum, col)
  end
  return _3_
end
local qf_older_key = "<"
local qf_newer_key = ">"
local function get_quickfix_history_size()
  return vim.fn.getqflist({nr = "$"}).nr
end
local function get_quickfix_current_index()
  return vim.fn.getqflist({nr = 0}).nr
end
local function has_older_qf_stack_entry_3f()
  return (get_quickfix_current_index() > 1)
end
local function has_newer_qf_stack_entry_3f()
  return (get_quickfix_current_index() < get_quickfix_history_size())
end
local function qf_older_fn()
  if has_older_qf_stack_entry_3f() then
    return vim.api.nvim_command("silent colder")
  else
    return nil
  end
end
local function qf_newer_fn()
  if has_newer_qf_stack_entry_3f() then
    return vim.api.nvim_command("silent cnewer")
  else
    return nil
  end
end
local function get_quickfix_title()
  local title = vim.fn.getqflist({title = 1}).title
  if (title == "") then
    return "quickfix list"
  else
    return title
  end
end
local function quickfix_title()
  return {{" \239\145\145 ", guibg = "fg", guifg = "black"}, (" " .. get_quickfix_title() .. " ")}
end
local function quickfix_history_nav()
  if (get_quickfix_history_size() > 1) then
    local _8_
    if has_older_qf_stack_entry_3f() then
      _8_ = "fg"
    else
      _8_ = "fg"
    end
    local _10_
    if has_newer_qf_stack_entry_3f() then
      _10_ = "fg"
    else
      _10_ = "fg"
    end
    return {{(" " .. qf_older_key .. " "), guifg = _8_}, {(get_quickfix_current_index() .. "/" .. get_quickfix_history_size()), guifg = "fg"}, {(" " .. qf_newer_key .. " "), guifg = _10_}}
  else
    return ""
  end
end
M["set-quickfix-mappings"] = function()
  local opts = {buffer = 0, silent = true, nowait = true}
  vim.keymap.set("n", "<c-v>", on_alternative_open("vsplit"), opts)
  vim.keymap.set("n", "<c-x>", on_alternative_open("split"), opts)
  vim.keymap.set("n", qf_older_key, qf_older_fn, opts)
  return vim.keymap.set("n", qf_newer_key, qf_newer_fn, opts)
end
M["quickfix-winbar-component"] = function()
  return {quickfix_title(), quickfix_history_nav()}
end
return M
