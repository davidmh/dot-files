(import-macros {: augroup} :own.macros)

(fn setup-buffer []
  (set vim.wo.conceallevel 3))

(augroup :neorg-buf-enter [:BufEnter {:callback setup-buffer}])
