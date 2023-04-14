(module own.plugins {autoload {config own.config
                               {: load-plugins} own.lazy}})

(load-plugins
  ;; lazy.nvim should manage itself
  :folke/lazy.nvim {}

  :Olical/aniseed {:dependencies [:Olical/conjure]}

  :folke/neodev.nvim {:dependencies [:nvim-neotest/neotest]
                      :opts {:library {:plugins [:neotest]
                                       :types true}}}

  ;; LSP
  :williamboman/mason.nvim {:dependencies [:neovim/nvim-lspconfig
                                           :williamboman/mason-lspconfig.nvim
                                           :folke/neodev.nvim
                                           :onsails/lspkind-nvim
                                           :hrsh7th/cmp-nvim-lsp
                                           :j-hui/fidget.nvim
                                           :kevinhwang91/nvim-ufo]
                            :mod :lsp}

  ;; Diagnostics
  ; :jose-elias-alvarez/null-ls.nvim
  :davidmh/null-ls.nvim {:dependencies [:nvim-lua/plenary.nvim]
                         :branch :cspell-code-action-custom-dictionaries
                         :mod :diagnostics}

  :petertriho/cmp-git {:dependencies [:nvim-lua/plenary.nvim]}

  ;; Completion
  :hrsh7th/nvim-cmp {:dependencies [:hrsh7th/cmp-nvim-lsp
                                    :hrsh7th/cmp-buffer
                                    :PaterJason/cmp-conjure
                                    :saadparwaiz1/cmp_luasnip
                                    :L3MON4D3/LuaSnip
                                    :davidmh/cmp-nerdfonts
                                    :onsails/lspkind-nvim
                                    :petertriho/cmp-git]
                     :mod :completion}

  ; ;; Debugger Adapter Protocol
  :mfussenegger/nvim-dap {:mod :dap
                          :dependencies [:rcarriga/nvim-dap-ui
                                         :theHamsta/nvim-dap-virtual-text]
                          :event :VeryLazy}

  ;; Tests
  :nvim-neotest/neotest {:dependencies [:nvim-lua/plenary.nvim
                                        :nvim-treesitter/nvim-treesitter
                                        :nvim-neotest/neotest-plenary
                                        :olimorris/neotest-rspec]
                         :mod :testing}

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
                                 :folke/which-key.nvim
                                 :norcalli/nvim-terminal.lua
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
  :nvim-treesitter/playground {:cmd :TSPlaygroundToggle}
  :nvim-treesitter/nvim-treesitter {:dependencies [:nvim-treesitter/playground
                                                   :nvim-treesitter/nvim-treesitter-context]
                                    :build ::TSUpdate
                                    :mod :tree-sitter}
  :nvim-treesitter/nvim-treesitter-context {:mod :context}

  ;; Icons
  :kyazdani42/nvim-web-devicons {:opts {:override {:scm {:color :#A6E3A1
                                                         :icon :ﬦ
                                                         :name :Scheme}}}}

  ;; Lists
  :nvim-telescope/telescope.nvim {:dependencies [:nvim-lua/plenary.nvim
                                                 :nvim-lua/popup.nvim
                                                 :rcarriga/nvim-notify]
                                  :mod :telescope}
  :folke/trouble.nvim {:dependencies [:kyazdani42/nvim-web-devicons]
                       :opts {:icons true
                              :signs {:error config.icons.ERROR
                                      :warning config.icons.WARN
                                      :hint config.icons.HINT
                                      :information config.icons.INFO
                                      :other "﫠"}
                              :group false}}

  ;; improved quickfix window {}
  :kevinhwang91/nvim-bqf {}

  ;; improved folding
  :kevinhwang91/nvim-ufo {:dependencies [:kevinhwang91/promise-async]
                          :mod :ultra-fold}

  ;; Organize mappings to encourage mnemonics
  :folke/which-key.nvim {:dependencies [:lewis6991/gitsigns.nvim]
                         :mod :which-key}

  ;; TMUX integration
  :christoomey/vim-tmux-navigator {}

  ;; Status line
  :freddiehaddad/feline.nvim {:dependencies [:kyazdani42/nvim-web-devicons]
                              :branch :main
                              :mod :feline}

  :rcarriga/nvim-notify {:dependencies [:nvim-telescope/telescope.nvim
                                        :catppuccin]
                         :mod :notify}

  ;; Improve vim.ui.input and vim.ui.select
  :stevearc/dressing.nvim {:opts {:select {:backend :telescope}
                                  :telescope {:layout_config {:width #(math.min $2 80)
                                                              :height #(math.min $2 15)}}}}

  :chomosuke/term-edit.nvim {:ft :toggleterm
                             :version :1.*}
  ;; Manage terminal buffers in splits, tabs, etc
  :akinsho/toggleterm.nvim {:branch :main
                            :dependencies [:chomosuke/term-edit.nvim]
                            :mod :toggle-term}

  ;; Databases
  :tpope/vim-dadbod  {:dependencies [:kristijanhusak/vim-dadbod-completion
                                     :kristijanhusak/vim-dadbod-ui]
                      :cmd [:DB :DBUIToggle]
                      :mod :db}

  ;; netrwho?
  :stevearc/oil.nvim {:mod :oil}
  :chrishrb/gx.nvim {:event [:BufEnter]
                     :config true}

  ;; open files from a terminal buffer in the current instance
  :willothy/flatten.nvim {:mod :flatten}

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
  :AndrewRadev/switch.vim {:mod :switch})
