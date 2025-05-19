(local {: autoload} (require :nfnl.module))
(local git (autoload :own.git))

;; Copy the file or range remote URL to the system clipboard
(vim.api.nvim_create_user_command :GCopy #(git.copy-remote-url) {:range true :nargs 0})
