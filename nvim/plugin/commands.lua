-- [nfnl] plugin/commands.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_.autoload
local git = autoload("own.git")
local snacks = autoload("snacks")
local function _2_()
  return git["copy-remote-url"]()
end
vim.api.nvim_create_user_command("GCopy", _2_, {range = true, nargs = 0})
local function _3_()
  return snacks.terminal.toggle("tetrigo --db ~/.config/tetrigo/tetrigo.db", {cwd = (vim.env.HOME .. "/.config/tetrigo"), win = {position = "float"}})
end
vim.api.nvim_create_user_command("Tetris", _3_, {nargs = 0})
local function _4_()
  return snacks.terminal.toggle("gh-dash --config ~/.config/gh-dash/config.yml", {win = {position = "float"}})
end
vim.api.nvim_create_user_command("GitHub", _4_, {nargs = 0})
local function _5_()
  return snacks.terminal.toggle("lazydocker", {win = {position = "float"}})
end
vim.api.nvim_create_user_command("Docker", _5_, {nargs = 0})
local process_compose = "process-compose list 2>/dev/null && process-compose attach || process-compose up -f process-compose.yaml --detached-with-tui"
local function _6_()
  return snacks.terminal.toggle(process_compose, {win = {position = "float"}, cwd = vim.fs.root(0, "process-compose.yaml")})
end
vim.api.nvim_create_user_command("ProcessCompose", _6_, {nargs = 0})
local function _7_()
  vim.cmd("mksession! /tmp/session.vim | restart source /tmp/session.vim")
  return vim.system({"rm", "/tmp/session.vim"})
end
vim.api.nvim_create_user_command("Restart", _7_, {nargs = 0})
local function messages()
  vim.cmd.redir("=> g:qf_messages")
  vim.cmd("silent! messages")
  vim.cmd.redir("END")
  local function _8_(item)
    return item.text
  end
  if (vim.g.qf_messages ~= table.concat(vim.tbl_map(_8_, vim.fn.getqflist()), "\n")) then
    local function _9_(_241)
      return {text = _241, lnum = 0}
    end
    vim.fn.setqflist({}, " ", {items = vim.tbl_map(_9_, vim.split(vim.g.qf_messages, "\n")), nr = "$", title = "Messages"})
  else
  end
  vim.cmd.copen()
  return vim.cmd.normal("G")
end
return vim.api.nvim_create_user_command("Messages", messages, {nargs = 0})
