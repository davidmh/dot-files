(import-macros {: use} :own.macros)

(use :yetone/avante.nvim {:cmd [:AvanteAsk :AvanteFocus]
                          :keys [:<leader>aa :<leader>ae]
                          :version false
                          :opts {:provider :gemini}
                          :build :make
                          :dependencies [:stevearc/dressing.nvim
                                         :nvim-lua/plenary.nvim
                                         :MunifTanjim/nui.nvim]})
