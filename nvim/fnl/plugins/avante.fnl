(import-macros {: use} :own.macros)

(use :yetone/avante.nvim {:event :VeryLazy
                          :lazy false
                          :version false
                          :opts {:provider :gemini}
                          :build :make
                          :dependencies [:stevearc/dressing.nvim
                                         :nvim-lua/plenary.nvim
                                         :MunifTanjim/nui.nvim
                                         (use :HakonHarnes/img-clip.nvim {:event :VeryLazy
                                                                          :opts {:default {:embed_image_as_base64 false
                                                                                           :prompt_for_file_name false
                                                                                           :drag_and_drop {:insert_mode true}}}})]})
