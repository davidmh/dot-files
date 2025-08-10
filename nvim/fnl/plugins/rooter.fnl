(import-macros {: tx} :own.macros)

[(tx :airblade/vim-rooter {:config #(do
                                      (set vim.g.rooter_patterns [:.git
                                                                  :.obsidian
                                                                  :lazy-lock.json])
                                      (set vim.g.rooter_silent_chdir true))})]
