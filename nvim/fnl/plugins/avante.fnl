(import-macros {: use} :own.macros)

(use :yetone/avante.nvim {:version false
                          :event :VeryLazy
                          :opts {}
                          :build :make
                          :dependencies [:nvim-lua/plenary.nvim
                                         :MunifTanjim/nui.nvim]})
