(import-macros {: tx} :own.macros)
(local colors (require :own.colors))

(tx :rebelot/kanagawa.nvim {:init #(vim.cmd.colorscheme :kanagawa)
                            :opts {:colors {:theme {:all {:ui {:bg_gutter :none}}}}
                                   :overrides colors.get-highlights}})
