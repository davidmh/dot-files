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
return load_plugins("folke/lazy.nvim", {}, "Olical/nfnl", {config = _4_, dependencies = {"Olical/conjure"}}, "folke/neodev.nvim", {dependencies = {"nvim-neotest/neotest"}, opts = {library = {plugins = {"neotest"}, types = true}}}, "davidmh/nvim-navic", {dev = true, lazy = true, branch = "feature/format_text", name = "nvim-navic"}, "j-hui/fidget.nvim", {tag = "legacy"}, "williamboman/mason.nvim", {dependencies = {"neovim/nvim-lspconfig", "williamboman/mason-lspconfig.nvim", "folke/neodev.nvim", "onsails/lspkind-nvim", "j-hui/fidget.nvim", "nvim-navic", "pmizio/typescript-tools.nvim"}, name = "mason", mod = "lsp"}, "jose-elias-alvarez/null-ls.nvim", {dependencies = {"nvim-lua/plenary.nvim", "davidmh/cspell.nvim"}, mod = "diagnostics"}, "petertriho/cmp-git", {dependencies = {"nvim-lua/plenary.nvim"}, event = "InsertEnter"}, "hrsh7th/nvim-cmp", {dependencies = {"hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-buffer", "PaterJason/cmp-conjure", "saadparwaiz1/cmp_luasnip", "L3MON4D3/LuaSnip", "davidmh/cmp-nerdfonts", "onsails/lspkind-nvim", "petertriho/cmp-git", "hrsh7th/cmp-emoji"}, event = "InsertEnter", mod = "completion"}, "zbirenbaum/copilot.lua", {mod = "copilot", event = "InsertEnter"}, "remix.nvim", {dir = "$REMIX_HOME/.nvim", name = "remix", config = _6_}, "tpope/vim-git", {mod = "git", dependencies = {"tpope/vim-fugitive", "tpope/vim-rhubarb", "nvim-lua/plenary.nvim", "sindrets/diffview.nvim", "lewis6991/gitsigns.nvim", "norcalli/nvim-terminal.lua", "nvim-telescope/telescope.nvim"}, event = "VeryLazy"}, "tpope/vim-rails", {ft = "ruby"}, "tpope/vim-rake", {ft = "ruby"}, "gpanders/nvim-parinfer", {ft = {"clojure", "fennel", "query"}}, "catppuccin/nvim", {name = "catppuccin", mod = "colorscheme", lazy = false}, "yasuhiroki/circleci.vim", {ft = "yaml.circleci"}, "nvim-treesitter/nvim-treesitter", {dependencies = {"JoosepAlviste/nvim-ts-context-commentstring", "numToStr/Comment.nvim"}, build = ":TSUpdate", mod = "tree-sitter"}, "nvim-tree/nvim-web-devicons", {opts = {override = {scm = {color = "#A6E3A1", name = "query", icon = "\239\172\166"}, fnl = {color = "cyan", name = "blue", icon = "\238\142\164"}}}}, "nvim-telescope/telescope.nvim", {dependencies = {"nvim-lua/plenary.nvim", "nvim-lua/popup.nvim", "rcarriga/nvim-notify"}, mod = "telescope"}, "folke/trouble.nvim", {dependencies = {"nvim-tree/nvim-web-devicons"}, opts = {icons = true, signs = {error = icons.ERROR, warning = icons.WARN, hint = icons.HINT, information = icons.INFO, other = "\239\171\160"}, group = false}}, "rebelot/heirline.nvim", {dependencies = {"catppuccin", "nvim-tree/nvim-web-devicons"}, mod = "status-lines"}, "rcarriga/nvim-notify", {dependencies = {"nvim-telescope/telescope.nvim", "catppuccin"}, mod = "notify"}, "stevearc/dressing.nvim", {opts = {select = {backend = "telescope"}, telescope = {layout_config = {width = _7_, height = _8_}}}}, "chomosuke/term-edit.nvim", {ft = "toggleterm", version = "1.*", opts = {prompt_end = " [ "}}, "akinsho/toggleterm.nvim", {branch = "main", dependencies = {"chomosuke/term-edit.nvim"}, opts = {shade_terminals = false}}, "tpope/vim-dadbod", {dependencies = {"kristijanhusak/vim-dadbod-completion", "kristijanhusak/vim-dadbod-ui"}, cmd = {"DB", "DBUIToggle"}, mod = "db"}, "stevearc/oil.nvim", {mod = "oil", keys = {"-", "|"}}, "chrishrb/gx.nvim", {keys = {"gx"}, config = true}, "willothy/flatten.nvim", {mod = "flatten"}, "nvim-neorg/neorg", {build = ":Neorg sync-parsers", dependencies = {"nvim-lua/plenary.nvim", "nvim-treesitter/nvim-treesitter"}, opts = {load = {["core.defaults"] = {}, ["core.concealer"] = {}, ["core.completion"] = {config = {engine = "nvim-cmp"}}, ["core.integrations.treesitter"] = {config = {configure_parsers = true, install_parsers = true}}, ["core.export"] = {config = {export_dir = "/tmp/"}}, ["core.export.markdown"] = {config = {extension = ".md"}}, ["core.dirman"] = {config = {workspaces = {notes = "~/Documents/neorg"}}}}}}, "airblade/vim-rooter", {config = _9_}, "danilamihailov/beacon.nvim", {}, "tommcdo/vim-exchange", {keys = {"cx", "cX", "c<Space>"}}, "radenling/vim-dispatch-neovim", {dependencies = {"tpope/vim-dispatch"}}, "tpope/vim-eunuch", {}, "tpope/vim-repeat", {}, "tpope/vim-scriptease", {}, "tpope/vim-surround", {}, "tpope/vim-unimpaired", {}, "tpope/vim-projectionist", {}, "tpope/vim-speeddating", {keys = {"<C-a>", "<C-x>"}}, "junegunn/vim-slash", {}, "junegunn/vim-easy-align", {config = _10_, keys = {"ga"}}, "vim-scripts/BufOnly.vim", {}, "mg979/vim-visual-multi", {}, "Valloric/ListToggle", {mod = "list-toggle"}, "AndrewRadev/switch.vim", {mod = "switch"})
