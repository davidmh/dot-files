(local {: autoload} (require :nfnl.module))
(local git (autoload :own.git))
(local snacks (autoload :snacks))

;; Copy the file or range remote URL to the system clipboard
(vim.api.nvim_create_user_command :GCopy #(git.copy-remote-url) {:range true :nargs 0})

(vim.api.nvim_create_user_command :Tetris
                                  #(snacks.terminal.toggle "tetrigo --db ~/.config/tetrigo/tetrigo.db"
                                                           {:cwd (.. vim.env.HOME :/.config/tetrigo)
                                                            :win {:position :float}})
                                  {:nargs 0})

(vim.api.nvim_create_user_command :GitHub
                                  #(snacks.terminal.toggle "gh-dash --config ~/.config/gh-dash/config.yml"
                                                           {:win {:position :float}})
                                  {:nargs 0})


(vim.api.nvim_create_user_command :Docker
                                  #(snacks.terminal.toggle :lazydocker
                                                           {:win {:position :float}})
                                  {:nargs 0})
