(local data-path (vim.fn.stdpath :data))

(fn ensure [user repo alias]
  (let [install-path (string.format "%s/lazy/%s" data-path (or alias repo))
        repo-url (string.format "https://github.com/%s/%s" user repo)]
    (when (> (vim.fn.empty (vim.fn.glob install-path)) 0)
      (vim.fn.system [:git :clone :--filter=blob:none :--single-branch repo-url install-path]))
    (vim.opt.runtimepath:prepend install-path)))

(ensure :folke :lazy.nvim)
(ensure :Olical :nfnl)
(ensure :catppuccin :nvim :catppuccin)
