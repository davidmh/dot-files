(import-macros {: map} :own.macros)
(local {: autoload} (require :nfnl.module))

(local {: border : icons} (autoload :own.config))
(local load-plugins (require :own.lazy))

(load-plugins
  ;; lazy.nvim should manage itself
  :folke/lazy.nvim {}

  :Olical/nfnl {:config true
                :dependencies [:Olical/conjure
                               :clojure-vim/vim-jack-in]
                :config #(do
                           (set vim.g.conjure#log#hud#border border)
                           (set vim.g.conjure#filetype#sql nil)
                           (set vim.g.conjure#filetype#python nil))}

  :folke/neodev.nvim {:opts {:library {:types true}}}

  :echasnovski/mini.starter {:mod :starter}

  ; cli tools manager
  :williamboman/mason.nvim {:mod :mason}

  ;; LSP
  :j-hui/fidget.nvim {:tag :v1.0.0}
  :neovim/nvim-lspconfig {:dependencies [:williamboman/mason.nvim
                                         :williamboman/mason-lspconfig.nvim
                                         :onsails/lspkind-nvim
                                         :j-hui/fidget.nvim
                                         :SmiteshP/nvim-navic
                                         :pmizio/typescript-tools.nvim]
                          :mod :lsp}

  ;; Diagnostics
  :davidmh/cspell.nvim {:dependencies [:nvim-lua/plenary.nvim]}
  :nvimtools/none-ls.nvim {:dependencies [:nvim-lua/plenary.nvim
                                          :davidmh/cspell.nvim]
                           :mod :diagnostics}

  :petertriho/cmp-git {:dependencies [:nvim-lua/plenary.nvim]
                       :event :InsertEnter}

  ;; Completion
  :hrsh7th/nvim-cmp {:dependencies [:hrsh7th/cmp-nvim-lsp
                                    :hrsh7th/cmp-buffer
                                    :PaterJason/cmp-conjure
                                    :saadparwaiz1/cmp_luasnip
                                    :L3MON4D3/LuaSnip
                                    :davidmh/cmp-nerdfonts
                                    :onsails/lspkind-nvim
                                    :petertriho/cmp-git
                                    :hrsh7th/cmp-emoji]
                     :event :InsertEnter
                     :mod :completion}

  :zbirenbaum/copilot.lua {:mod :copilot
                           :event :InsertEnter}

  :remix.nvim {:dir :$REMIX_HOME/.nvim
               :name :remix
               :config #(-> (require :remix)
                            (: :setup))}

  ;; Git
  :tpope/vim-git {:mod :git
                  :dependencies [:tpope/vim-fugitive
                                 :tpope/vim-rhubarb
                                 :nvim-lua/plenary.nvim
                                 :sindrets/diffview.nvim
                                 :lewis6991/gitsigns.nvim
                                 :norcalli/nvim-terminal.lua]
                  :event :VeryLazy}

  ;; Ruby
  :tpope/vim-rails {:ft :ruby}
  :tpope/vim-rake {:ft :ruby}

  ;; (parens (for (days)))
  :gpanders/nvim-parinfer {:ft [:clojure :fennel :query]}

  ;; Colorscheme
  :catppuccin/nvim {:name :catppuccin
                    :mod :colorscheme
                    :lazy false}

  ;; Syntax hightlighting
  ; :yasuhiroki/circleci.vim {:ft :yaml.circleci}
  :nvim-treesitter/nvim-treesitter {:dependencies [:JoosepAlviste/nvim-ts-context-commentstring
                                                   :numToStr/Comment.nvim]
                                    :build ::TSUpdate
                                    :mod :tree-sitter}

  ;; Icons
  :nvim-tree/nvim-web-devicons {:opts {:override {:scm {:color :#A6E3A1
                                                        :name :query
                                                        :icon :󰘧}
                                                  :fnl {:color :cyan
                                                        :name :blue
                                                        :icon :}}}}

  ;; Lists
  :nvim-telescope/telescope.nvim {:dependencies [:nvim-lua/plenary.nvim
                                                 :nvim-lua/popup.nvim
                                                 :rcarriga/nvim-notify]
                                  :event :VeryLazy
                                  :mod :telescope}
  :folke/trouble.nvim {:dependencies [:nvim-tree/nvim-web-devicons]
                       :opts {:icons true
                              :signs {:error icons.ERROR
                                      :warning icons.WARN
                                      :hint icons.HINT
                                      :information icons.INFO
                                      :other "﫠"}
                              :padding false
                              :group false}}

  ;; Status lines
  :rebelot/heirline.nvim {:dependencies [:nvim-tree/nvim-web-devicons]
                          :mod :status-lines}

  :rcarriga/nvim-notify {:dependencies [:nvim-telescope/telescope.nvim]
                         :mod :notify
                         :event :VeryLazy}

  ;; Improve vim.ui.input and vim.ui.select
  :stevearc/dressing.nvim {:event :VeryLazy
                           :opts {:select {:backend :telescope}
                                  :telescope {:layout_config {:width #(math.min $2 80)
                                                              :height #(math.min $2 15)}}}}

  :chomosuke/term-edit.nvim {:ft :toggleterm
                             :version :1.*
                             :opts {:prompt_end " [ "}}
  ;; Manage terminal buffers in splits tabs etc
  :akinsho/toggleterm.nvim {:branch :main
                            :dependencies [:chomosuke/term-edit.nvim]
                            :opts {:shade_terminals false}}

  ;; Databases
  :tpope/vim-dadbod  {:dependencies [:kristijanhusak/vim-dadbod-completion
                                     :kristijanhusak/vim-dadbod-ui]
                      :cmd [:DB :DBUIToggle]
                      :mod :db}

  ;; netrwho?
  :s1n7ax/nvim-window-picker {:event :VeryLazy
                              :opts {}}
  :nvim-neo-tree/neo-tree.nvim {:branch :v3.x
                                :dependencies [:nvim-lua/plenary.nvim
                                               :kyazdani42/nvim-web-devicons
                                               :MunifTanjim/nui.nvim
                                               :s1n7ax/nvim-window-picker]
                                :mod :neo-tree}

  :chrishrb/gx.nvim {:keys [:gx]
                     :config true}

  ;; open files from a terminal buffer in the current instance
  :willothy/flatten.nvim {:mod :flatten}

  :nvim-neorg/neorg {:build ":Neorg sync-parsers"
                     :dependencies [:nvim-lua/plenary.nvim
                                    :nvim-treesitter/nvim-treesitter]
                     :ft :norg
                     :mod :neorg}

  :airblade/vim-rooter {:config #(do
                                   (set vim.g.rooter_patterns [:lazy-lock.json :.git])
                                   (set vim.g.rooter_silent_chdir true))}

  :folke/which-key.nvim {:dependencies [:nvim-lua/plenary.nvim]
                         :event :VeryLazy
                         :mod :which-key}

  ;; Misc Utilities
  :danilamihailov/beacon.nvim {}
  :tommcdo/vim-exchange {:keys [:cx :cX :c<Space> :X]}
  :radenling/vim-dispatch-neovim {:dependencies [:tpope/vim-dispatch]}
  :tpope/vim-eunuch  {}
  :tpope/vim-repeat  {}
  :tpope/vim-scriptease  {}
  :tpope/vim-surround  {}
  :tpope/vim-unimpaired  {}
  :tpope/vim-projectionist  {}
  :junegunn/vim-slash  {}
  :junegunn/vim-easy-align {:config #(map [:x :n] :ga "<Plug>(EasyAlign)")
                            :keys [:ga]}
  :vim-scripts/BufOnly.vim {}
  :mg979/vim-visual-multi  {}
  :Valloric/ListToggle {:mod :list-toggle}
  :AndrewRadev/switch.vim {:mod :switch})
