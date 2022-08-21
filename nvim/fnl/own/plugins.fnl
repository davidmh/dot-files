(module own.plugins
  {autoload {core aniseed.core
             nvim aniseed.nvim
             packer packer
             util packer.util}})

; luarocks fails to install packages on macOS BigSur
; https://github.com/wbthomason/packer.nvim/issues/180#issuecomment-871634199
(when (string.match (vim.fn.system "uname -s") "Darwin")
  (vim.fn.setenv :MACOSX_DEPLOYMENT_TARGET :10.15))

(defn- safe-require-plugin-config [name]
  (let [(ok? val-or-err) (pcall require (.. "own.plugin." name))]
    (when (not ok?)
      (print (.. "Plugin config error: " val-or-err)))))

(defn use [...]
  (let [pkgs [...]]
    (packer.startup
      (fn [use]
        (for [i 1 (core.count pkgs) 2]
          (let [name (. pkgs i)
                opts (. pkgs (+ i 1))]
             (-?> (. opts :mod) (safe-require-plugin-config))
             (use (core.assoc opts 1 name))))))))

(use
  ;; Packer can manage itself
  :wbthomason/packer.nvim {}

  :lewis6991/impatient.nvim {}

  :Olical/aniseed {:requires [:Olical/conjure]}

  ;; LSP
  :williamboman/mason.nvim {:requires [:neovim/nvim-lspconfig
                                       :williamboman/mason-lspconfig.nvim
                                       :folke/lua-dev.nvim
                                       :onsails/lspkind-nvim
                                       :j-hui/fidget.nvim]
                            :mod :lsp}

  ;; Diagnostics
  :jose-elias-alvarez/null-ls.nvim {:requires [:nvim-lua/plenary.nvim]
                                    :mod :diagnostics}

  ;; Completion
  :hrsh7th/nvim-cmp {:requires [:hrsh7th/cmp-nvim-lsp
                                :hrsh7th/cmp-buffer
                                :hrsh7th/cmp-emoji
                                :PaterJason/cmp-conjure
                                :saadparwaiz1/cmp_luasnip
                                :L3MON4D3/LuaSnip
                                :rafamadriz/friendly-snippets]
                     :mod :completion}

  :github/copilot.vim {:mod :copilot}

  "~/Projects/remix/.nvim" {:as :remix.nvim
                            :mod :remix}

  ;; Git
  :tpope/vim-git {:mod :git
                  :requires [:tpope/vim-fugitive
                             :tpope/vim-rhubarb
                             :nvim-lua/plenary.nvim
                             :sindrets/diffview.nvim
                             :lewis6991/gitsigns.nvim]
                  :after [:nvim-telescope/telescope.nvim]}

  :ldelossa/gh.nvim {:requires [:ldelossa/litee.nvim]
                     :mod :gh}

  ;; Ruby
  :tpope/vim-rails {}
  :tpope/vim-rake {}
  :joker1007/vim-ruby-heredoc-syntax {}

  ;; (parens (for (days)))
  :gpanders/nvim-parinfer {}
  :clojure-vim/vim-jack-in {}

  ;; Colorscheme
  ; :rmehri01/onenord.nvim {:branch :main :mod :colorscheme}
  :catppuccin/nvim {:as :catppuccin :mod :colorscheme}

  ;; Syntax hightlighting
  :yasuhiroki/circleci.vim {}
  :aklt/plantuml-syntax {}
  :nvim-treesitter/nvim-treesitter {:run ":TSUpdate"
                                    :requires :nvim-treesitter/playground
                                    :mod :tree-sitter}

  ;; org-mode
  :nvim-orgmode/orgmode {:mod :org
                         :requires [:akinsho/org-bullets.nvim]}

  ;; Lists
  :nvim-telescope/telescope.nvim {:requires [:nvim-lua/plenary.nvim :nvim-lua/popup.nvim]
                                  :mod :telescope}
  :folke/trouble.nvim {:requires :kyazdani42/nvim-web-devicons
                       :mod :trouble}

  ;; improved quickfix window {}
  :kevinhwang91/nvim-bqf {}

  ;; Organize mappings to encourage mnemonics
  :folke/which-key.nvim {:mod :which-key
                         :requires [:mrjones2014/legendary.nvim]}

  ;; TMUX integration
  :christoomey/vim-tmux-navigator {}
  :christoomey/vim-tmux-runner {}

  ;; Status line
  :feline-nvim/feline.nvim {:require :kyazdani42/nvim-web-devicons
                            :mod :feline}

  ;; Notifications in floating windows
  :rcarriga/nvim-notify {:mod :notify}

  ;; Improve vim.ui.input and vim.ui.select
  :stevearc/dressing.nvim {:mod :dressing}

  :akinsho/toggleterm.nvim {:branch :main
                            :mod :toggle-term}

  ;; Databases
  :tpope/vim-dadbod  {:requires [:kristijanhusak/vim-dadbod-completion
                                 :kristijanhusak/vim-dadbod-ui]
                      :mod :db}

  ;; Misc Utilities
  :tommcdo/vim-exchange {}
  :tpope/vim-commentary  {}
  :radenling/vim-dispatch-neovim {:requires :tpope/vim-dispatch}
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
  :weirongxu/plantuml-previewer.vim {:requires :tyru/open-browser.vim})
