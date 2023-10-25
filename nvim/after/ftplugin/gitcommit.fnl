(import-macros {: augroup} :own.macros)

(fn setup-buffer []
  (set vim.bo.textwidth 72))

(augroup :git-commit-buf-enter [:BufEnter {:callback setup-buffer
                                           :buffer 0}])
