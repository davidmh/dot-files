(import-macros {: tx} :own.macros)

(tx :yetone/avante.nvim {:version false
                         :event :VeryLazy
                         :opts {:provider :copilot}
                         :build :make
                         :dependencies [:nvim-lua/plenary.nvim
                                        :MunifTanjim/nui.nvim]})
