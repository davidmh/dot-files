-- [nfnl] Compiled from fnl/own/options.fnl by https://github.com/Olical/nfnl, do not edit.
vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.o.cmdheight = 1
vim.o.cursorline = true
vim.o.expandtab = true
vim.o.foldlevel = 99
vim.o.grepprg = "ag -S --vimgrep"
vim.o.guifont = "Hasklug Nerd Font:h14"
vim.o.hidden = true
vim.o.ignorecase = true
vim.o.inccommand = "split"
vim.o.laststatus = 3
vim.o.list = true
vim.o.listchars = "tab:\226\150\184 ,trail:\194\183"
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
vim.g.GuiWindowFrameless = true
vim.g.ruby_host_prog = vim.fn.exepath("neovim-ruby-host")
local function os_open(url)
  return vim.fn.system(("xdg-open " .. url .. " || open " .. url))
end
local function _1_(opts)
  return os_open(opts.args)
end
return vim.api.nvim_create_user_command("Browse", _1_, {nargs = 1})
