(import-macros {: tx} :own.macros)

[(tx :airblade/vim-rooter {:config #(do
                                      (set vim.g.rooter_patterns [:.git
                                                                  :.obsidian
                                                                  :Gemfile
                                                                  :package.json
                                                                  :Cargo.toml
                                                                  :pyproject.toml
                                                                  :lazy-lock.json])
                                      (set vim.g.rooter_silent_chdir true))})]
