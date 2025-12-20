-- [nfnl] fnl/own/options.fnl
local _local_1_ = require("nfnl.module")
local autoload = _local_1_.autoload
local cfg = autoload("own.config")
vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.o.conceallevel = 2
vim.o.cursorline = false
vim.o.expandtab = true
vim.o.foldlevel = 99
vim.o.grepprg = "ag -S --vimgrep"
vim.o.guifont = "Hasklug Nerd Font:h14"
vim.o.hidden = true
vim.o.ignorecase = true
vim.o.inccommand = "split"
vim.o.number = false
vim.o.laststatus = 3
vim.o.list = true
vim.o.listchars = "tab:\239\148\163 ,trail:\194\183"
vim.o.mouse = "a"
vim.o.scrolloff = 0
vim.o.shiftwidth = 2
vim.o.smartcase = true
vim.o.softtabstop = 2
vim.o.tabstop = 2
vim.o.timeoutlen = 500
vim.o.termguicolors = true
vim.o.updatetime = 100
vim.wo.wrap = false
vim.o.splitright = true
vim.o.winborder = "solid"
vim.o.confirm = true
local function get_source_name(diagnostic)
  local or_2_ = diagnostic.source
  if not or_2_ then
    local tmp_3_ = diagnostic.namespace
    if (nil ~= tmp_3_) then
      local tmp_3_0 = vim.diagnostic.get_namespace(tmp_3_)
      if (nil ~= tmp_3_0) then
        or_2_ = tmp_3_0.name
      else
        or_2_ = nil
      end
    else
      or_2_ = nil
    end
  end
  return (or_2_ or ("ns:" .. tostring(diagnostic.namespace)))
end
local function diagnostic_format(diagnostic)
  return (cfg.icons[diagnostic.severity] .. " [" .. get_source_name(diagnostic) .. "] " .. diagnostic.message)
end
return vim.diagnostic.config({underline = true, severity_sort = true, float = {format = diagnostic_format, header = {}}, signs = false, update_in_insert = false, virtual_lines = false, virtual_text = false})
