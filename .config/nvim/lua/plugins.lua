-- Recompile packer on save
vim.cmd([[
  augroup auto-source
    au!
    au BufWritePost plugins.lua PackerCompile
  augroup END
]])

return require('packer').startup(function()
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- LSP
  use {
    'neovim/nvim-lspconfig',
    requires = {
      { 'kabouzeid/nvim-lspinstall' },
      { 'nvim-lua/lsp-status.nvim' },
      { 'glepnir/lspsaga.nvim' },
    },
    config = function() require('config.lsp') end
  }

  -- Completion
  use {
    'hrsh7th/nvim-compe',
    config = function() require('config.completion') end
  }

  -- Linting/fixing
  use {
    'dense-analysis/ale',
    config = function() require('config.ale') end
  }

  -- Git
  use 'tpope/vim-git'
  use { 'tpope/vim-fugitive', requires = { 'tpope/vim-rhubarb' } }
  use {
    'lewis6991/gitsigns.nvim',
    requires = { 'nvim-lua/plenary.nvim' },
    config = function() require('config.gitsigns') end
  }

  -- Ruby
  use 'tpope/vim-rails'
  use 'tpope/vim-rake'
  use 'joker1007/vim-ruby-heredoc-syntax'

  -- Colorschemes
  use 'arcticicestudio/nord-vim'

  -- Syntax hightlighting
  use 'yasuhiroki/circleci.vim'
  use {
    'nvim-treesitter/nvim-treesitter',
    run = ':TSUpdate',
    config = function() require('config.tree-sitter') end
  }

  -- Lists
  use {
    'junegunn/fzf.vim',
    requires = { { 'junegunn/fzf', run = './install --all' } }
  }
  use {
    'nvim-telescope/telescope.nvim',
    requires = {
      { 'nvim-lua/popup.nvim' },
      { 'nvim-lua/plenary.nvim' },
    },
    config = function() require('config.telescope') end
  }
  use 'kevinhwang91/nvim-bqf'

  -- Organize mappings to encourage mnemonics
  use {
    'folke/which-key.nvim',
    config = function() require('config.which-key') end
  }

  -- TMUX integration
  use 'christoomey/vim-tmux-navigator'
  use 'christoomey/vim-tmux-runner'

  -- Terminal mode improvements
  use 'wincent/terminus'

  -- Status line
  use {
    'glepnir/galaxyline.nvim',
    branch = 'main',
    requires = { 'kyazdani42/nvim-web-devicons' },
    config = function() require('config.galaxyline') end
  }

  -- Snippets
  use {
    'norcalli/snippets.nvim',
    config = function() require('config.snippets') end
  }

  -- Misc Utilities
  use 'tommcdo/vim-exchange'
  use 'tpope/vim-commentary'
  use 'tpope/vim-dadbod'
  use 'tpope/vim-dispatch'
  use 'tpope/vim-eunuch'
  use 'tpope/vim-repeat'
  use 'tpope/vim-scriptease'
  use 'tpope/vim-surround'
  use 'tpope/vim-unimpaired'
  use 'tpope/vim-projectionist'
  use 'junegunn/vim-slash'
  use {
    'junegunn/vim-easy-align',
    config = function()
      -- Start in visual mode (e.g. vipga)
      vim.cmd('xmap ga <Plug>(EasyAlign)')
      -- Start for a motion/text object (e.g. gaip)
      vim.cmd('nmap ga <Plug>(EasyAlign)')
    end
  }
  use 'junegunn/vim-peekaboo'
  use 'vim-scripts/BufOnly.vim'
  use 'mg979/vim-visual-multi'
  use 'voldikss/vim-floaterm'
  use {
    'Valloric/ListToggle',
    config = function()
      vim.g.lt_location_list_toggle_map = 'L'
      vim.g.lt_quickfix_list_toggle_map = 'Q'
    end
  }
  use {
    'AndrewRadev/switch.vim',
    config = function() vim.g.switch_mapping = '!' end
  }
  use {
    'norcalli/nvim-colorizer.lua',
    config = function() require('colorizer').setup() end
  }
  use {
    'folke/todo-comments.nvim',
    requires = 'nvim-lua/plenary.nvim',
    config = function() require('todo-comments').setup() end
  }
end)
