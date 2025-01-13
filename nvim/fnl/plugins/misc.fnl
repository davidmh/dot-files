(import-macros {: use} :own.macros)

[(use :airblade/vim-rooter {:config #(do
                                       (set vim.g.rooter_patterns [:lazy-lock.json :.git :.obsidian :.envrc :.rspec])
                                       (set vim.g.rooter_silent_chdir true))})

 (use :Valloric/ListToggle {:event :VeryLazy
                            :config #(do
                                      (set vim.g.lt_location_list_toggle_map :L)
                                      (set vim.g.lt_quickfix_list_toggle_map :Q))})]
