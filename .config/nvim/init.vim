" install plugins
call plug#begin(stdpath('config') . '/bundle')
  " LSP
  Plug 'neovim/nvim-lspconfig'
  Plug 'kabouzeid/nvim-lspinstall'
  Plug 'nvim-lua/lsp-status.nvim'
  Plug 'glepnir/lspsaga.nvim'

  " Completion
  Plug 'hrsh7th/nvim-compe'

  " Linting/fixing
  Plug 'dense-analysis/ale'

  " Git
  Plug 'tpope/vim-fugitive' | Plug 'tpope/vim-rhubarb'
  Plug 'tpope/vim-git'

  " Ruby
  Plug 'tpope/vim-rails'
  Plug 'tpope/vim-rake'
  Plug 'joker1007/vim-ruby-heredoc-syntax'

  " Colorschemes
  Plug 'gruvbox-community/gruvbox'
  Plug 'junegunn/seoul256.vim'
  Plug 'romainl/Apprentice'
  Plug 'arcticicestudio/nord-vim'
  Plug 'dracula/vim'
  Plug 'joshdick/onedark.vim'

  " Syntax hightlighting
  Plug 'yasuhiroki/circleci.vim'
  Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}

  " Lists
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
  Plug 'junegunn/fzf.vim'
  Plug 'nvim-telescope/telescope.nvim' | Plug 'nvim-telescope/telescope-fzf-native.nvim', { 'do': 'make' }
  Plug 'kevinhwang91/nvim-bqf'

  " The lua invasion
  Plug 'nvim-lua/popup.nvim'
  Plug 'nvim-lua/plenary.nvim'
  Plug 'lewis6991/gitsigns.nvim'
  Plug 'folke/zen-mode.nvim'
  Plug 'folke/which-key.nvim'

  " TMUX integration
  Plug 'christoomey/vim-tmux-navigator'
  Plug 'christoomey/vim-tmux-runner'

  " Terminal mode improvements
  Plug 'wincent/terminus'

  " Status line
  Plug 'glepnir/galaxyline.nvim' , {'branch': 'main'} | Plug 'kyazdani42/nvim-web-devicons'

  " Misc Utilities
  Plug 'tommcdo/vim-exchange'
  Plug 'tpope/vim-commentary'
  Plug 'tpope/vim-dadbod'
  Plug 'tpope/vim-dispatch'
  Plug 'tpope/vim-eunuch'
  Plug 'tpope/vim-repeat'
  Plug 'tpope/vim-scriptease'
  Plug 'tpope/vim-surround'
  Plug 'tpope/vim-unimpaired'
  Plug 'tpope/vim-projectionist'
  Plug 'junegunn/vim-slash'
  Plug 'junegunn/vim-easy-align'
  Plug 'junegunn/vim-peekaboo'
  Plug 'Valloric/ListToggle'
  Plug 'vim-scripts/BufOnly.vim'
  Plug 'AndrewRadev/switch.vim'
  Plug 'mg979/vim-visual-multi'
  Plug 'norcalli/snippets.nvim'
  Plug 'voldikss/vim-floaterm'
  Plug 'norcalli/nvim-colorizer.lua'
call plug#end()

let g:mapleader = "\<SPACE>"

set cursorline
set expandtab
set grepprg=rg\ -S\ --vimgrep
set guifont=Dank\ Mono:h15
set hidden
set ignorecase
set inccommand=split
set laststatus=2
set list listchars=tab:▸\ ,trail:·
set mouse=a
set noemoji " fixes some spacing issues with emoji spacing
set nowrap
set shiftwidth=2
set signcolumn=yes
set smartcase
set softtabstop=2
set tabstop=2
set termguicolors
set updatetime=100

" config files
command! Kittyrc tabedit $HOME/.config/kitty/kitty.conf
command! Luarc tabedit $HOME/.config/nvim/lua/
command! Tmuxrc tabedit $HOME/.tmux.conf
command! Vimrc tabedit $HOME/.config/nvim/init.vim
command! Zshrc tabedit $HOME/.zshrc

" auto-reload
augroup VimrcAutoSource
  au!
  au BufWritePost $HOME/.config/nvim/init.vim source <afile>
augroup END

" let &t_8f="\<Esc>[38;2;%lu;%lu;%lum"
" let &t_8b="\<Esc>[48;2;%lu;%lu;%lum"

let $TERM='screen-256color-italic'
let s:plug_url = 'https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
let s:plug_target = stdpath('data') . '/site/autoload/plug.vim'

" Load vim-plug
if empty(glob(s:plug_target))
  execute '!curl -fLo ' . s:plug_target . ' --create-dirs ' . s:plug_url
endif

colorscheme nord

" Remove the background from the current colorscheme to fallback to the
" colorscheme in the terminal
hi Normal     ctermbg=NONE guibg=NONE
hi LineNr     ctermbg=NONE guibg=NONE
hi SignColumn ctermbg=NONE guibg=NONE
hi Comment cterm=italic gui=italic guifg=DarkGray

" Enable spelling checks while writing git commits
augroup git_commit_spell
  au!
  au FileType gitcommit setlocal spell
augroup END

" EasyAlign
" Start in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

lua require('utilities')
lua require('plugin-settings')
lua require('lsp')
lua require('tree-sitter-config')
lua require('completion')
lua require('snippets-config')
lua require('colorizer').setup()
lua require('gitsigns').setup()
lua require('status-line')
lua require('telescope-config')
lua require('confirm-quit')
lua require('which-key-config')

source $HOME/.config/nvim/settings/remaps.vim
source $HOME/.config/nvim/settings/lists.vim
source $HOME/.config/nvim/settings/remix.vim
