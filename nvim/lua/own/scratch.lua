-- [nfnl] Compiled from fnl/own/scratch.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local core = autoload("nfnl.core")
local state = {bufnr = nil}
local function new_scratch_split()
  vim.cmd("botright split")
  vim.api.nvim_win_set_buf(vim.api.nvim_get_current_win(), state.bufnr)
  return vim.cmd("normal G")
end
local function initialize()
  local bufnr = vim.api.nvim_create_buf(false, false)
  vim.api.nvim_buf_set_option(bufnr, "filetype", "fennel")
  vim.api.nvim_buf_set_option(bufnr, "buftype", "nofile")
  vim.api.nvim_buf_set_lines(bufnr, 0, 0, true, {"(local core (require :nfnl.core))", "", ""})
  do end (state)["bufnr"] = bufnr
  new_scratch_split()
  return vim.cmd("ConjureEvalBuf")
end
local function show()
  if (state.bufnr == nil) then
    return initialize()
  else
    local winid = core.first(vim.fn.win_findbuf(state.bufnr))
    if (winid == nil) then
      return new_scratch_split()
    else
      return vim.fn.win_gotoid(winid)
    end
  end
end
local function kill()
  if (-1 ~= state.bufnr) then
    do
      local winid = vim.fn.bufwinid(state.bufnr)
      local current_winid = vim.fn.winnr("$")
      if ((-1 ~= winid) and (winid == current_winid) and (1 ~= winid)) then
        vim.api.nvim_win_close(winid, false)
      else
      end
    end
    vim.api.nvim_buf_delete(state.bufnr, {force = true})
    do end (state)["bufnr"] = nil
    return nil
  else
    return vim.notify("Nothing to kill")
  end
end
return {show = show, kill = kill}
