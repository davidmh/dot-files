-- [nfnl] Compiled from fnl/own/plugins.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local _local_2_ = autoload("own.config")
local border = _local_2_["border"]
local icons = _local_2_["icons"]
local load_plugins = require("own.lazy")
local function _3_()
  vim.g["conjure#log#hud#border"] = border
  vim.g["conjure#filetype#sql"] = nil
  vim.g["conjure#filetype#python"] = nil
  return nil
end
local function _4_()
  return require("remix"):setup()
end
local function _5_(_241, _242)
  return math.min(_242, 80)
end
local function _6_(_241, _242)
  return math.min(_242, 15)
end
local function _7_()
  vim.g.rooter_patterns = {"lazy-lock.json", ".git"}
  vim.g.rooter_silent_chdir = true
  return nil
end
local function _8_()
  return vim.keymap.set({"x", "n"}, "ga", "<Plug>(EasyAlign)")
end
return load_plugins("folke/lazy.nvim", {}, "Olical/nfnl", {config = _3_, dependencies = {"Olical/conjure", "clojure-vim/vim-jack-in"}}, "folke/neodev.nvim", {opts = {library = {types = true}}}, "echasnovski/mini.starter", {mod = "starter"}, "williamboman/mason.nvim", {mod = "mason"}, "j-hui/fidget.nvim", {tag = "v1.0.0"}, "neovim/nvim-lspconfig", {dependencies = {"williamboman/mason.nvim", "williamboman/mason-lspconfig.nvim", "onsails/lspkind-nvim", "j-hui/fidget.nvim", "SmiteshP/nvim-navic", "pmizio/typescript-tools.nvim"}, mod = "lsp"}, "davidmh/cspell.nvim", {dependencies = {"nvim-lua/plenary.nvim"}}, "nvimtools/none-ls.nvim", {dependencies = {"nvim-lua/plenary.nvim", "davidmh/cspell.nvim"}, mod = "diagnostics"}, "petertriho/cmp-git", {dependencies = {"nvim-lua/plenary.nvim"}, event = "InsertEnter"}, "hrsh7th/nvim-cmp", {dependencies = {"hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "PaterJason/cmp-conjure", "saadparwaiz1/cmp_luasnip", "L3MON4D3/LuaSnip", "davidmh/cmp-nerdfonts", "onsails/lspkind-nvim", "petertriho/cmp-git", "hrsh7th/cmp-emoji"}, event = "InsertEnter", mod = "completion"}, "zbirenbaum/copilot.lua", {mod = "copilot", event = "InsertEnter"}, "remix.nvim", {dir = "$REMIX_HOME/.nvim", name = "remix", config = _4_}, "tpope/vim-git", {mod = "git", dependencies = {"tpope/vim-fugitive", "tpope/vim-rhubarb", "nvim-lua/plenary.nvim", "sindrets/diffview.nvim", "lewis6991/gitsigns.nvim", "norcalli/nvim-terminal.lua"}, event = "VeryLazy"}, "tpope/vim-rails", {ft = "ruby"}, "tpope/vim-rake", {ft = "ruby"}, "gpanders/nvim-parinfer", {ft = {"clojure", "fennel", "query"}}, "catppuccin/nvim", {name = "catppuccin", mod = "colorscheme", lazy = false}, "nvim-treesitter/nvim-treesitter", {dependencies = {"JoosepAlviste/nvim-ts-context-commentstring", "numToStr/Comment.nvim"}, build = ":TSUpdate", mod = "tree-sitter"}, "nvim-tree/nvim-web-devicons", {opts = {override = {scm = {color = "#A6E3A1", name = "query", icon = "\243\176\152\167"}, fnl = {color = "cyan", name = "blue", icon = "\238\143\146"}}}}, "nvim-telescope/telescope.nvim", {dependencies = {"nvim-lua/plenary.nvim", "nvim-lua/popup.nvim", "rcarriga/nvim-notify"}, event = "VeryLazy", mod = "telescope"}, "folke/trouble.nvim", {dependencies = {"nvim-tree/nvim-web-devicons"}, opts = {icons = true, signs = {error = icons.ERROR, warning = icons.WARN, hint = icons.HINT, information = icons.INFO, other = "\239\171\160"}, group = false, padding = false}}, "rebelot/heirline.nvim", {dependencies = {"nvim-tree/nvim-web-devicons"}, mod = "status-lines"}, "rcarriga/nvim-notify", {dependencies = {"nvim-telescope/telescope.nvim"}, mod = "notify", event = "VeryLazy"}, "stevearc/dressing.nvim", {event = "VeryLazy", opts = {select = {backend = "telescope"}, telescope = {layout_config = {width = _5_, height = _6_}}}}, "chomosuke/term-edit.nvim", {ft = "toggleterm", version = "1.*", opts = {prompt_end = " [ "}}, "akinsho/toggleterm.nvim", {branch = "main", dependencies = {"chomosuke/term-edit.nvim"}, opts = {shade_terminals = false}}, "tpope/vim-dadbod", {dependencies = {"kristijanhusak/vim-dadbod-completion", "kristijanhusak/vim-dadbod-ui"}, cmd = {"DB", "DBUIToggle"}, mod = "db"}, "s1n7ax/nvim-window-picker", {event = "VeryLazy", opts = {}}, "nvim-neo-tree/neo-tree.nvim", {branch = "v3.x", dependencies = {"nvim-lua/plenary.nvim", "kyazdani42/nvim-web-devicons", "MunifTanjim/nui.nvim", "s1n7ax/nvim-window-picker"}, mod = "neo-tree"}, "chrishrb/gx.nvim", {keys = {"gx"}, config = true}, "willothy/flatten.nvim", {mod = "flatten"}, "nvim-neorg/neorg", {build = ":Neorg sync-parsers", dependencies = {"nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter"}, ft = "norg", mod = "neorg"}, "airblade/vim-rooter", {config = _7_}, "folke/which-key.nvim", {dependencies = {"nvim-lua/plenary.nvim"}, event = "VeryLazy", mod = "which-key"}, "danilamihailov/beacon.nvim", {}, "tommcdo/vim-exchange", {keys = {"cx", "cX", "c<Space>", "X"}}, "radenling/vim-dispatch-neovim", {dependencies = {"tpope/vim-dispatch"}}, "tpope/vim-eunuch", {}, "tpope/vim-repeat", {}, "tpope/vim-scriptease", {}, "tpope/vim-surround", {}, "tpope/vim-unimpaired", {}, "tpope/vim-projectionist", {}, "junegunn/vim-slash", {}, "junegunn/vim-easy-align", {config = _8_, keys = {"ga"}}, "vim-scripts/BufOnly.vim", {}, "mg979/vim-visual-multi", {}, "Valloric/ListToggle", {mod = "list-toggle"}, "AndrewRadev/switch.vim", {mod = "switch"})
