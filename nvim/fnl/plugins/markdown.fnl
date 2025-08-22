(import-macros {: tx} :own.macros)

[(tx :iamcco/markdown-preview.nvim {:cmd [:MarkdownPreviewToggle
                                          :MarkdownPreview
                                          :MarkdownPreviewStop]
                                     :event :VeryLazy
                                     :build #(vim.fn.mkdp#util#install)})]
