-- [nfnl] Compiled from after/ftplugin/fennel.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local _local_2_ = autoload("own.lists")
local find = _local_2_["find"]
local _local_3_ = autoload("nfnl.core")
local empty_3f = _local_3_["empty?"]
local _local_4_ = autoload("nfnl.config")
local find_and_load = _local_4_["find-and-load"]
require("own.fennel-lua-paths"):setup()
local function find_window_id_by_path(path)
  local function _5_(_241)
    return (vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(_241)) == path)
  end
  return find(_5_, vim.api.nvim_list_wins())
end
local function find_compiled_lua_path(fennel_path)
  local _local_6_ = find_and_load(vim.fn.stdpath("config"))
  local cfg = _local_6_["cfg"]
  local find_lua_path = cfg({"fnl-path->lua-path"})
  return find_lua_path(fennel_path)
end
local function maybe_refresh_compiled_buffer_window()
  local fnl_window_id = vim.fn.win_getid()
  local lua_window_id = find_window_id_by_path(find_compiled_lua_path(vim.fn.expand("%:p")))
  if lua_window_id then
    local function _7_()
      vim.fn.win_gotoid(lua_window_id)
      vim.cmd("edit")
      return vim.fn.win_gotoid(fnl_window_id)
    end
    return vim.schedule(_7_)
  else
    return nil
  end
end
do
  local group = vim.api.nvim_create_augroup("fennel-refresh-compiled-buffer", {clear = true})
  vim.api.nvim_create_autocmd("BufWritePost", {pattern = "*.fnl", callback = maybe_refresh_compiled_buffer_window, group = group})
end
local function setup_scratch_buffer()
  local content = vim.api.nvim_buf_get_lines(0, 0, -1, true)
  if empty_3f(table.concat(content, "")) then
    vim.api.nvim_buf_set_lines(0, 0, -1, true, {";; scratch", "", "(comment", "  (let [nfnl (require :nfnl.api)]", "    (nfnl.compile-all-files (vim.fn.expand :$HOME/.config/home-manager/nvim))"})
    return vim.cmd("normal GG")
  else
    return nil
  end
end
local group = vim.api.nvim_create_augroup("fennel-scratch-buffer", {clear = true})
vim.api.nvim_create_autocmd("BufEnter", {pattern = "/tmp/scratch.fnl", callback = setup_scratch_buffer, group = group})
return nil
