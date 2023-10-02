-- [nfnl] Compiled from after/ftplugin/fennel.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local _local_2_ = autoload("own.lists")
local find = _local_2_["find"]
local _local_3_ = autoload("nfnl.config")
local find_and_load = _local_3_["find-and-load"]
require("own.fennel-lua-paths"):setup()
local function find_window_id_by_path(path)
  local function _4_(_241)
    return (vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(_241)) == path)
  end
  return find(_4_, vim.api.nvim_list_wins())
end
local function find_compiled_lua_path(fennel_path)
  local _local_5_ = find_and_load(vim.fn.stdpath("config"))
  local cfg = _local_5_["cfg"]
  local find_lua_path = cfg({"fnl-path->lua-path"})
  return find_lua_path(fennel_path)
end
local function maybe_refresh_compiled_buffer_window()
  local fnl_window_id = vim.fn.win_getid()
  local lua_window_id = find_window_id_by_path(find_compiled_lua_path(vim.fn.expand("%:p")))
  if lua_window_id then
    vim.fn.win_gotoid(lua_window_id)
    vim.cmd("sleep! 10m")
    vim.cmd("e!")
    return vim.fn.win_gotoid(fnl_window_id)
  else
    return nil
  end
end
local group = vim.api.nvim_create_augroup("fennel-refresh-compiled-buffer", {clear = true})
vim.api.nvim_create_autocmd("BufWritePost", {pattern = "*.fnl", callback = maybe_refresh_compiled_buffer_window, group = group})
return nil
