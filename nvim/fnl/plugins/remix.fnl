(import-macros {: use} :own.macros)

(use :remix.nvim {:dir :$REMIX_HOME/.nvim
                  :dependencies [:hrsh7th/nvim-cmp]
                  :name :remix
                  :opts {}})
