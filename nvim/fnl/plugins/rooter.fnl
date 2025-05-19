(import-macros {: tx} :own.macros)

[(tx :airblade/vim-rooter {:config #(do
                                      (set vim.g.rooter_patterns [:.envrc
                                                                  :.git
                                                                  :.obsidian
                                                                  :.rspec
                                                                  :Cargo.toml
                                                                  :lazy-lock.json
                                                                  :yarn.lock
                                                                  :pyproject.toml])
                                      (set vim.g.rooter_silent_chdir true))})]
