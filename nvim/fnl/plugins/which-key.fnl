(import-macros {: tx} :own.macros)
(local {: border} (require :own.config))

(tx :folke/which-key.nvim {:event :VeryLazy
                           :opts {:preset :helix
                                  :show_help false
                                  :win {: border}}})
