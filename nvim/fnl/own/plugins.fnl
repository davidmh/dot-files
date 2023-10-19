(import-macros {: map} :own.macros)
(local {: autoload} (require :nfnl.module))

(local {: compile-all-files} (autoload :nfnl))
(local {: border : icons} (autoload :own.config))
(local load-plugins (require :own.lazy))

(load-plugins
  ;; lazy.nvim should manage itself
  :folke/lazy.nvim {}

  :Olical/nfnl {:config true
                :dependencies [:Olical/conjure]
                :config #(do
                           (set vim.g.conjure#log#hud#border border)
                           (set vim.g.conjure#filetype#sql nil)
                           (set vim.g.conjure#filetype#python nil)
                           (vim.api.nvim_create_user_command :NfnlCompileAllFiles
                                                             #(compile-all-files (vim.fn.stdpath :config))
                                                             {:nargs 0}))}

  :folke/neodev.nvim {:dependencies [:nvim-neotest/neotest]
                      :opts {:library {:plugins [:neotest]
                                       :types true}}}

  ;; LSP
  :davidmh/nvim-navic {:dev true
                       :lazy true
                       :branch :feature/format_text
                       :name :nvim-navic}
  :j-hui/fidget.nvim {:tag :legacy}
  :williamboman/mason.nvim {:dependencies [:neovim/nvim-lspconfig
                                           :williamboman/mason-lspconfig.nvim
                                           :folke/neodev.nvim
                                           :onsails/lspkind-nvim
                                           :j-hui/fidget.nvim
                                           :nvim-navic
                                           :pmizio/typescript-tools.nvim]
                            :name :mason
                            :mod :lsp}

  ;; Diagnostics
  :jose-elias-alvarez/null-ls.nvim {:dependencies [:nvim-lua/plenary.nvim
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
                                 ; :folke/which-key.nvim
                                 :norcalli/nvim-terminal.lua
                                 :nvim-telescope/telescope.nvim]
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
  :yasuhiroki/circleci.vim {:ft :yaml.circleci}
  :nvim-treesitter/nvim-treesitter {:dependencies [:JoosepAlviste/nvim-ts-context-commentstring
                                                   :numToStr/Comment.nvim]
                                    :build ::TSUpdate
                                    :mod :tree-sitter}

  ;; Icons
  :nvim-tree/nvim-web-devicons {:opts {:override {:scm {:color :#A6E3A1
                                                        :name :query
                                                        :icon :ﬦ}
                                                  :fnl {:color :cyan
                                                        :name :blue
                                                        :icon :}}}}

  ;; Lists
  :nvim-telescope/telescope.nvim {:dependencies [:nvim-lua/plenary.nvim
                                                 :nvim-lua/popup.nvim
                                                 :rcarriga/nvim-notify]
                                  :mod :telescope}
  :folke/trouble.nvim {:dependencies [:nvim-tree/nvim-web-devicons]
                       :opts {:icons true
                              :signs {:error icons.ERROR
                                      :warning icons.WARN
                                      :hint icons.HINT
                                      :information icons.INFO
                                      :other "﫠"}
                              :group false}}

  ;; Organize mappings to encourage mnemonics
  :folke/which-key.nvim {:dependencies [:lewis6991/gitsigns.nvim]
                         :mod :which-key}

  ;; Status lines
  :rebelot/heirline.nvim {:dependencies [:catppuccin
                                         :nvim-tree/nvim-web-devicons]
                          :mod :status-lines}

  :rcarriga/nvim-notify {:dependencies [:nvim-telescope/telescope.nvim
                                        :catppuccin]
                         :mod :notify}

  ;; Improve vim.ui.input and vim.ui.select
  :stevearc/dressing.nvim {:opts {:select {:backend :telescope}
                                  :telescope {:layout_config {:width #(math.min $2 80)
                                                              :height #(math.min $2 15)}}}}

  :chomosuke/term-edit.nvim {:ft :toggleterm
                             :version :1.*}
  ;; Manage terminal buffers in splits tabs etc
  :akinsho/toggleterm.nvim {:branch :main
                            :dependencies [:chomosuke/term-edit.nvim]
                            :mod :toggle-term}

  ;; Databases
  :tpope/vim-dadbod  {:dependencies [:kristijanhusak/vim-dadbod-completion
                                     :kristijanhusak/vim-dadbod-ui]
                      :cmd [:DB :DBUIToggle]
                      :mod :db}

  ;; netrwho?
  :stevearc/oil.nvim {:mod :oil
                      :keys [:- :|]}
  :chrishrb/gx.nvim {:keys [:gx]
                     :config true}

  ;; open files from a terminal buffer in the current instance
  :willothy/flatten.nvim {:mod :flatten}

  ; ;; orgmode - are we there yet?
  :nvim-orgmode/orgmode {:dependencies [:nvim-treesitter/nvim-treesitter
                                        :akinsho/org-bullets.nvim]
                         :ft :org
                         :mod :org}

  :airblade/vim-rooter {:config #(do
                                   (set vim.g.rooter_patterns [:lazy-lock.json :.git])
                                   (set vim.g.rooter_silent_chdir true))}

  ;; Misc Utilities
  :danilamihailov/beacon.nvim {}
  :tommcdo/vim-exchange {:keys [:cx :cX :c<Space>]}
  :radenling/vim-dispatch-neovim {:dependencies [:tpope/vim-dispatch]}
  :tpope/vim-eunuch  {}
  :tpope/vim-repeat  {}
  :tpope/vim-scriptease  {}
  :tpope/vim-surround  {}
  :tpope/vim-unimpaired  {}
  :tpope/vim-projectionist  {}
  :tpope/vim-speeddating {:keys [:<C-a> :<C-x>]}
  :junegunn/vim-slash  {}
  :junegunn/vim-easy-align {:config #(map [:x :n] :ga "<Plug>(EasyAlign)")
                            :keys [:ga]}
  :vim-scripts/BufOnly.vim {:keys :<leader>bo}
  :mg979/vim-visual-multi  {:keys [:<C-n> :\\A]}
  :Valloric/ListToggle {:mod :list-toggle}
  :AndrewRadev/switch.vim {:mod :switch})
