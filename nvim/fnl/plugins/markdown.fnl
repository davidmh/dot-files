(import-macros {: use} :own.macros)

[(use :iamcco/markdown-preview.nvim {:cmd [:MarkdownPreviewToggle
                                            :MarkdownPreview
                                            :MarkdownPreviewStop]
                                      :ft [:markdown]
                                      :build #(vim.fn.mkdp#util#install)})
 (use :MeanderingProgrammer/render-markdown.nvim {:opts {:file_types [:markdown :Avante]}
                                                  :ft [:markdown :Avante]})]
