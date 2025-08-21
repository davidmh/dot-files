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

(fn messages []
  ;; capture the messages into a global variable
  (vim.cmd.redir "=> g:qf_messages")
  (vim.cmd "silent! messages")
  (vim.cmd.redir :END)

  ;; create a new quickfix entry only if it's not already there
  (if (~= vim.g.qf_messages
          (table.concat
            (vim.tbl_map (fn [item] item.text)
                    (vim.fn.getqflist))
            "\n"))
      (vim.fn.setqflist [] " " {:items (vim.tbl_map #(-> {:text $1 :lnum 0})
                                                    (vim.split vim.g.qf_messages "\n"))
                                :nr :$
                                :title :Messages}))

  ;; open the quickfix window and go to the latest message
  (vim.cmd.copen)
  (vim.cmd.normal :G))

(vim.api.nvim_create_user_command :Messages messages {:nargs 0})
