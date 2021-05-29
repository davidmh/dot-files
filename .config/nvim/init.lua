vim.g.mapleader = ' '
vim.g.netrw_banner = 0

vim.o.cursorline = true
vim.o.expandtab = true
vim.o.grepprg = 'rg -S --vimgrep'
vim.o.guifont = 'Dank Mono:h15'
vim.o.hidden = true
vim.o.ignorecase = true
vim.o.inccommand = 'split'
vim.o.laststatus = 2
vim.o.list = true
vim.o.listchars = 'tab:▸ ,trail:·'
vim.o.mouse = 'a'
vim.o.shiftwidth = 2
vim.o.signcolumn = 'yes'
vim.o.smartcase = true
vim.o.softtabstop = 2
vim.o.tabstop = 2
vim.o.termguicolors = true
vim.o.updatetime = 100
vim.wo.wrap = false

-- packer
local packer_repo = 'https://github.com/wbthomason/packer.nvim'
local packer_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if vim.fn.glob(packer_path) == '' then
  print('Installing packer...')
  vim.cmd('!git clone ' .. packer_repo .. ' ' .. packer_path)
else
  require('plugins')
  vim.cmd('colorscheme nord')
end

require('confirm-quit')
require('window-management')

vim.cmd('source ' .. vim.fn.stdpath('config') .. '/commands.vim')
