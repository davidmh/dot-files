(import-macros {: tx} :own.macros)

[(tx :iamcco/markdown-preview.nvim {:cmd [:MarkdownPreviewToggle
                                          :MarkdownPreview
                                          :MarkdownPreviewStop]
                                     :event :VeryLazy
                                     :build #(vim.fn.mkdp#util#install)})
 (tx :MeanderingProgrammer/render-markdown.nvim {:opts {:file_types [:markdown :Avante]}
                                                 :ft [:markdown :Avante]})]
