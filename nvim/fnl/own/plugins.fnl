(module own.plugins
  {autoload {core aniseed.core
             nvim aniseed.nvim
             lazy lazy
             util packer.util}})

(defn- load-module [name]
  (let [(ok? val-or-err) (pcall require (.. "own.plugin." name))]
    (when (not ok?)
      (print (.. "Plugin config error: " val-or-err)))))

(defn- load-plugins [...]
  (let [pkgs [...]
        plugins []]
    (for [i 1 (core.count pkgs) 2]
      (let [name (. pkgs i)
            opts (. pkgs (+ i 1))
            mod (. opts :mod)
            plugin (core.merge {1 name} opts)]
        (when mod
          ; remove the mod key
          (tset plugin :mod nil)
          ; replace it with a config call
          (tset plugin :config #(load-module mod)))

        ; the first param defines the plugin URL, local plugins don't need it
        (if (. opts :dir)
          (table.remove plugin 1))

        ; add it to the list of plugins
        (table.insert plugins plugin)))
    (lazy.setup plugins {:ui {:border :rounded}})))

(load-plugins
  ;; lazy.nvim should manage itself
  :folke/lazy.nvim {}

  :Olical/aniseed {:dependencies [:Olical/conjure]}

  ;; LSP
  :williamboman/mason.nvim {:dependencies [:neovim/nvim-lspconfig
                                           :williamboman/mason-lspconfig.nvim
                                           :folke/neodev.nvim
                                           :onsails/lspkind-nvim
                                           :hrsh7th/cmp-nvim-lsp
                                           :j-hui/fidget.nvim]
                            :mod :lsp}

  ;; Diagnostics
  :jose-elias-alvarez/null-ls.nvim {:dependencies [:nvim-lua/plenary.nvim]
                                    :mod :diagnostics}

  ;; Completion
  :hrsh7th/nvim-cmp {:dependencies [:hrsh7th/cmp-nvim-lsp
                                    :hrsh7th/cmp-buffer
                                    :hrsh7th/cmp-emoji
                                    :PaterJason/cmp-conjure
                                    :saadparwaiz1/cmp_luasnip
                                    :davidmh/cmp-nerdfonts 
                                    :onsails/lspkind-nvim
                                    :L3MON4D3/LuaSnip
                                    :rafamadriz/friendly-snippets]
                     :mod :completion}

  :remix.nvim {:dir :$REMIX_HOME/.nvim
               :name :remix
               :mod :remix}

  ;; Git
  :tpope/vim-git {:mod :git
                  :dependencies [:tpope/vim-fugitive
                                 :tpope/vim-rhubarb
                                 :nvim-lua/plenary.nvim
                                 :sindrets/diffview.nvim
                                 :lewis6991/gitsigns.nvim
                                 :folke/which-key.nvim
                                 :nvim-telescope/telescope.nvim]}

  ;; Ruby
  :tpope/vim-rails {}
  :tpope/vim-rake {}

  ;; (parens (for (days)))
  :gpanders/nvim-parinfer {}
  :clojure-vim/vim-jack-in {}

  ;; Colorscheme
  :catppuccin/nvim {:name :catppuccin
                    :mod :colorscheme
                    :lazy false}

  ;; Syntax hightlighting
  :yasuhiroki/circleci.vim {}
  :aklt/plantuml-syntax {}
  :nvim-treesitter/nvim-treesitter {:dependencies [:nvim-treesitter/playground]
                                    :build ::TSUpdate
                                    :mod :tree-sitter}

  ;; Lists
  :nvim-telescope/telescope.nvim {:dependencies [:nvim-lua/plenary.nvim :nvim-lua/popup.nvim]
                                  :mod :telescope}
  :folke/trouble.nvim {:dependencies [:kyazdani42/nvim-web-devicons]
                       :mod :trouble}

  ;; improved quickfix window {}
  :kevinhwang91/nvim-bqf {}

  ;; Organize mappings to encourage mnemonics
  :folke/which-key.nvim {:dependencies [:lewis6991/gitsigns.nvim]
                         :mod :which-key}

  ;; TMUX integration
  :christoomey/vim-tmux-navigator {}

  ;; Status line
  :feline-nvim/feline.nvim {:dependencies [:kyazdani42/nvim-web-devicons
                                           :catppuccin/nvim]
                            :mod :feline}

  :rcarriga/nvim-notify {:dependencies [:nvim-telescope/telescope.nvim
                                        :catppuccin/nvim]
                         :lazy false
                         :mod :notify}

  ;; Improve vim.ui.input and vim.ui.select
  :stevearc/dressing.nvim {:mod :dressing}

  :akinsho/toggleterm.nvim {:branch :main
                            :mod :toggle-term}

  ;; Databases
  :tpope/vim-dadbod  {:dependencies [:kristijanhusak/vim-dadbod-completion
                                     :kristijanhusak/vim-dadbod-ui]
                      :mod :db}

  ;; Misc Utilities
  :tommcdo/vim-exchange {}
  :tpope/vim-commentary  {}
  :radenling/vim-dispatch-neovim {:dependencies [:tpope/vim-dispatch]}
  :tpope/vim-eunuch  {}
  :tpope/vim-repeat  {}
  :tpope/vim-scriptease  {}
  :tpope/vim-surround  {}
  :tpope/vim-unimpaired  {}
  :tpope/vim-projectionist  {}
  :junegunn/vim-slash  {}
  :junegunn/vim-easy-align {:mod :easy-align}
  :vim-scripts/BufOnly.vim  {}
  :mg979/vim-visual-multi  {}
  :Valloric/ListToggle {:mod :list-toggle}
  :AndrewRadev/switch.vim {:mod :switch}
  :weirongxu/plantuml-previewer.vim {:dependencies [:tyru/open-browser.vim]})
