-- [nfnl] Compiled from fnl/own/plugins.fnl by https://github.com/Olical/nfnl, do not edit.
local config = require("own.config")
local load_plugins = require("own.lazy")
local function _1_()
  vim.g["conjure#log#hud#border"] = config.border
  vim.g["conjure#filetype#sql"] = nil
  vim.g["conjure#filetype#python"] = nil
  return nil
end
local function _2_()
  return require("remix"):setup()
end
local function _3_(_241, _242)
  return math.min(_242, 80)
end
local function _4_(_241, _242)
  return math.min(_242, 15)
end
local function _5_()
  vim.g.rooter_patterns = {"lazy-lock.json", ".git"}
  vim.g.rooter_silent_chdir = true
  return nil
end
return load_plugins("folke/lazy.nvim", {}, "Olical/nfnl", {config = _1_, dependencies = {"Olical/conjure"}}, "folke/neodev.nvim", {dependencies = {"nvim-neotest/neotest"}, opts = {library = {plugins = {"neotest"}, types = true}}}, "j-hui/fidget.nvim", {tag = "legacy"}, "williamboman/mason.nvim", {dependencies = {"neovim/nvim-lspconfig", "williamboman/mason-lspconfig.nvim", "folke/neodev.nvim", "onsails/lspkind-nvim", "hrsh7th/cmp-nvim-lsp", "j-hui/fidget.nvim", "SmiteshP/nvim-navic", "pmizio/typescript-tools.nvim"}, name = "mason", mod = "lsp"}, "jose-elias-alvarez/null-ls.nvim", {dependencies = {"nvim-lua/plenary.nvim", "davidmh/cspell.nvim"}, mod = "diagnostics"}, "petertriho/cmp-git", {dependencies = {"nvim-lua/plenary.nvim"}}, "hrsh7th/nvim-cmp", {dependencies = {"hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "PaterJason/cmp-conjure", "saadparwaiz1/cmp_luasnip", "L3MON4D3/LuaSnip", "davidmh/cmp-nerdfonts", "onsails/lspkind-nvim", "petertriho/cmp-git", "hrsh7th/cmp-emoji"}, mod = "completion"}, "zbirenbaum/copilot.lua", {mod = "copilot", event = "InsertEnter"}, "remix.nvim", {dir = "$REMIX_HOME/.nvim", name = "remix", config = _2_}, "tpope/vim-git", {mod = "git", dependencies = {"tpope/vim-fugitive", "tpope/vim-rhubarb", "nvim-lua/plenary.nvim", "sindrets/diffview.nvim", "lewis6991/gitsigns.nvim", "norcalli/nvim-terminal.lua", "nvim-telescope/telescope.nvim"}}, "tpope/vim-rails", {}, "tpope/vim-rake", {}, "gpanders/nvim-parinfer", {}, "clojure-vim/vim-jack-in", {}, "catppuccin/nvim", {name = "catppuccin", mod = "colorscheme", lazy = false}, "yasuhiroki/circleci.vim", {}, "aklt/plantuml-syntax", {}, "nvim-treesitter/playground", {cmd = "TSPlaygroundToggle"}, "nvim-treesitter/nvim-treesitter", {dependencies = {"nvim-treesitter/playground", "JoosepAlviste/nvim-ts-context-commentstring", "numToStr/Comment.nvim"}, build = ":TSUpdate", mod = "tree-sitter"}, "nvim-tree/nvim-web-devicons", {opts = {override = {scm = {color = "#A6E3A1", name = "query", icon = "\239\172\166"}, fnl = {color = "cyan", name = "blue", icon = "\238\142\164"}}}}, "nvim-telescope/telescope.nvim", {dependencies = {"nvim-lua/plenary.nvim", "nvim-lua/popup.nvim", "rcarriga/nvim-notify"}, mod = "telescope"}, "folke/trouble.nvim", {dependencies = {"nvim-tree/nvim-web-devicons"}, opts = {icons = true, signs = {error = config.icons.ERROR, warning = config.icons.WARN, hint = config.icons.HINT, information = config.icons.INFO, other = "\239\171\160"}, group = false}}, "folke/which-key.nvim", {dependencies = {"lewis6991/gitsigns.nvim"}, mod = "which-key"}, "christoomey/vim-tmux-navigator", {}, "rebelot/heirline.nvim", {dependencies = {"catppuccin", "nvim-tree/nvim-web-devicons", "mason"}, mod = "status-lines"}, "rcarriga/nvim-notify", {dependencies = {"nvim-telescope/telescope.nvim", "catppuccin"}, mod = "notify"}, "stevearc/dressing.nvim", {opts = {select = {backend = "telescope"}, telescope = {layout_config = {width = _3_, height = _4_}}}}, "chomosuke/term-edit.nvim", {ft = "toggleterm", version = "1.*"}, "akinsho/toggleterm.nvim", {branch = "main", dependencies = {"chomosuke/term-edit.nvim"}, mod = "toggle-term"}, "tpope/vim-dadbod", {dependencies = {"kristijanhusak/vim-dadbod-completion", "kristijanhusak/vim-dadbod-ui"}, cmd = {"DB", "DBUIToggle"}, mod = "db"}, "stevearc/oil.nvim", {mod = "oil"}, "chrishrb/gx.nvim", {event = {"BufEnter"}, config = true}, "willothy/flatten.nvim", {mod = "flatten"}, "nvim-orgmode/orgmode", {dependencies = {"nvim-treesitter/nvim-treesitter", "akinsho/org-bullets.nvim"}, ft = "org", mod = "org"}, "airblade/vim-rooter", {config = _5_}, "danilamihailov/beacon.nvim", {}, "tommcdo/vim-exchange", {}, "radenling/vim-dispatch-neovim", {dependencies = {"tpope/vim-dispatch"}}, "tpope/vim-eunuch", {}, "tpope/vim-repeat", {}, "tpope/vim-scriptease", {}, "tpope/vim-surround", {}, "tpope/vim-unimpaired", {}, "tpope/vim-projectionist", {}, "tpope/vim-speeddating", {}, "junegunn/vim-slash", {}, "junegunn/vim-easy-align", {mod = "easy-align"}, "vim-scripts/BufOnly.vim", {}, "mg979/vim-visual-multi", {}, "Valloric/ListToggle", {mod = "list-toggle"}, "AndrewRadev/switch.vim", {mod = "switch"})
