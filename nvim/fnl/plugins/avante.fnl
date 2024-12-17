(import-macros {: use} :own.macros)

(use :yetone/avante.nvim {:event :VeryLazy
                          :lazy false
                          :version false
                          :opts {:provider :gemini}
                          :build :make
                          :dependencies [:stevearc/dressing.nvim
                                         :nvim-lua/plenary.nvim
                                         :MunifTanjim/nui.nvim]})
