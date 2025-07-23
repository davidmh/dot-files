(import-macros {: tx} :own.macros)

[(tx :R-nvim/cmp-r {:ft [:r]})
 (tx :R-nvim/R.nvim {:opts {}
                     :after [:hrsh7th/nvim-cmp]
                     :dependencies [:R-nvim/cmp-r]
                     :ft [:r]})]
