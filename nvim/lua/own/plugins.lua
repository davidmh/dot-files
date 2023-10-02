-- [nfnl] Compiled from fnl/own/plugins.fnl by https://github.com/Olical/nfnl, do not edit.
local _local_1_ = require("nfnl.module")
local autoload = _local_1_["autoload"]
local _local_2_ = autoload("nfnl")
local compile_all_files = _local_2_["compile-all-files"]
local _local_3_ = autoload("own.config")
local border = _local_3_["border"]
local icons = _local_3_["icons"]
local load_plugins = require("own.lazy")
local function _4_()
  vim.g["conjure#log#hud#border"] = border
  vim.g["conjure#filetype#sql"] = nil
  vim.g["conjure#filetype#python"] = nil
  local function _5_()
    return compile_all_files(vim.fn.stdpath("config"))
  end
  return vim.api.nvim_create_user_command("NfnlCompileAllFiles", _5_, {nargs = 0})
end
local function _6_()
  return require("remix"):setup()
end
local function _7_(_241, _242)
  return math.min(_242, 80)
end
local function _8_(_241, _242)
  return math.min(_242, 15)
end
local function _9_()
  vim.g.rooter_patterns = {"lazy-lock.json", ".git"}
  vim.g.rooter_silent_chdir = true
  return nil
end
local function _10_()
  return vim.keymap.set({"x", "n"}, "ga", "<Plug>(EasyAlign)")
end
return load_plugins("folke/lazy.nvim", {}, "Olical/nfnl", {config = _4_, dependencies = {"Olical/conjure"}}, "folke/neodev.nvim", {dependencies = {"nvim-neotest/neotest"}, opts = {library = {plugins = {"neotest"}, types = true}}}, "davidmh/nvim-navic", {dev = true, lazy = true, branch = "feature/format_text", name = "nvim-navic"}, "j-hui/fidget.nvim", {tag = "legacy"}, "williamboman/mason.nvim", {dependencies = {"neovim/nvim-lspconfig", "williamboman/mason-lspconfig.nvim", "folke/neodev.nvim", "onsails/lspkind-nvim", "hrsh7th/cmp-nvim-lsp", "j-hui/fidget.nvim", "nvim-navic", "pmizio/typescript-tools.nvim"}, name = "mason", mod = "lsp"}, "jose-elias-alvarez/null-ls.nvim", {dependencies = {"nvim-lua/plenary.nvim", "davidmh/cspell.nvim"}, mod = "diagnostics"}, "petertriho/cmp-git", {dependencies = {"nvim-lua/plenary.nvim"}}, "hrsh7th/nvim-cmp", {dependencies = {"hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "PaterJason/cmp-conjure", "saadparwaiz1/cmp_luasnip", "L3MON4D3/LuaSnip", "davidmh/cmp-nerdfonts", "onsails/lspkind-nvim", "petertriho/cmp-git", "hrsh7th/cmp-emoji"}, mod = "completion"}, "zbirenbaum/copilot.lua", {mod = "copilot", event = "InsertEnter"}, "remix.nvim", {dir = "$REMIX_HOME/.nvim", name = "remix", config = _6_}, "tpope/vim-git", {mod = "git", dependencies = {"tpope/vim-fugitive", "tpope/vim-rhubarb", "nvim-lua/plenary.nvim", "sindrets/diffview.nvim", "lewis6991/gitsigns.nvim", "norcalli/nvim-terminal.lua", "nvim-telescope/telescope.nvim"}}, "tpope/vim-rails", {}, "tpope/vim-rake", {}, "gpanders/nvim-parinfer", {}, "clojure-vim/vim-jack-in", {}, "catppuccin/nvim", {name = "catppuccin", mod = "colorscheme", lazy = false}, "yasuhiroki/circleci.vim", {}, "aklt/plantuml-syntax", {}, "nvim-treesitter/playground", {cmd = "TSPlaygroundToggle"}, "nvim-treesitter/nvim-treesitter", {dependencies = {"nvim-treesitter/playground", "JoosepAlviste/nvim-ts-context-commentstring", "numToStr/Comment.nvim"}, build = ":TSUpdate", mod = "tree-sitter"}, "nvim-tree/nvim-web-devicons", {opts = {override = {scm = {color = "#A6E3A1", name = "query", icon = "\239\172\166"}, fnl = {color = "cyan", name = "blue", icon = "\238\142\164"}}}}, "nvim-telescope/telescope.nvim", {dependencies = {"nvim-lua/plenary.nvim", "nvim-lua/popup.nvim", "rcarriga/nvim-notify"}, mod = "telescope"}, "folke/trouble.nvim", {dependencies = {"nvim-tree/nvim-web-devicons"}, opts = {icons = true, signs = {error = icons.ERROR, warning = icons.WARN, hint = icons.HINT, information = icons.INFO, other = "\239\171\160"}, group = false}}, "folke/which-key.nvim", {dependencies = {"lewis6991/gitsigns.nvim"}, mod = "which-key"}, "christoomey/vim-tmux-navigator", {}, "rebelot/heirline.nvim", {dependencies = {"catppuccin", "nvim-tree/nvim-web-devicons", "mason"}, mod = "status-lines"}, "rcarriga/nvim-notify", {dependencies = {"nvim-telescope/telescope.nvim", "catppuccin"}, mod = "notify"}, "stevearc/dressing.nvim", {opts = {select = {backend = "telescope"}, telescope = {layout_config = {width = _7_, height = _8_}}}}, "chomosuke/term-edit.nvim", {ft = "toggleterm", version = "1.*"}, "akinsho/toggleterm.nvim", {branch = "main", dependencies = {"chomosuke/term-edit.nvim"}, mod = "toggle-term"}, "tpope/vim-dadbod", {dependencies = {"kristijanhusak/vim-dadbod-completion", "kristijanhusak/vim-dadbod-ui"}, cmd = {"DB", "DBUIToggle"}, mod = "db"}, "stevearc/oil.nvim", {mod = "oil"}, "chrishrb/gx.nvim", {event = {"BufEnter"}, config = true}, "willothy/flatten.nvim", {mod = "flatten"}, "nvim-orgmode/orgmode", {dependencies = {"nvim-treesitter/nvim-treesitter", "akinsho/org-bullets.nvim"}, ft = "org", mod = "org"}, "airblade/vim-rooter", {config = _9_}, "danilamihailov/beacon.nvim", {}, "tommcdo/vim-exchange", {}, "radenling/vim-dispatch-neovim", {dependencies = {"tpope/vim-dispatch"}}, "tpope/vim-eunuch", {}, "tpope/vim-repeat", {}, "tpope/vim-scriptease", {}, "tpope/vim-surround", {}, "tpope/vim-unimpaired", {}, "tpope/vim-projectionist", {}, "tpope/vim-speeddating", {}, "junegunn/vim-slash", {}, "junegunn/vim-easy-align", {config = _10_}, "vim-scripts/BufOnly.vim", {}, "mg979/vim-visual-multi", {}, "Valloric/ListToggle", {mod = "list-toggle"}, "AndrewRadev/switch.vim", {mod = "switch"})
