(import-macros {: use} :own.macros)

(use :jalvesaq/Nvim-R {:dependencies [:hrsh7th/nvim-cmp]
                       :config #(set vim.g.R_assign 0)})
