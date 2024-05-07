(import-macros {: use : imap} :own.macros)

(fn config []
  (set vim.g.codeium_filetypes {:zsh false})
  (imap :<M-n> #(vim.fn.codeium#CycleCompletions 1))
  (imap :<M-p> #(vim.fn.codeium#CycleCompletions -1))
  (imap :<M-x> #(vim.fn.codeium#Clear)))

(use :Exafunction/codeium.vim {:event :BufEnter
                               :dependencies [:nvim-lua/plenary.nvim]
                               : config})
