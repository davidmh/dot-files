(import-macros {: augroup} :own.macros)

(fn setup-buffer []
  (set vim.wo.conceallevel 3)
  (when (= (vim.api.nvim_buf_get_name 0) :neorg://toc)
    (vim.api.nvim_win_set_width 0 50)))

(augroup :neorg-buf-enter [:BufEnter {:callback setup-buffer}])
