(import-macros {: use : imap} :own.macros)

(set vim.g.codeium_filetypes {:zsh false
                              :TelescopePropmt false})
(set vim.g.codeium_enabled true)
(set vim.g.codeium_no_map_tab true)

(local expr true)
(local silent true)

(fn codeium-accept []
  (vim.fn.codeium#Accept))

(fn codeium-next []
  (vim.fn.codeium#CycleCompletions 1))

(fn codeium-prev []
  (vim.fn.codeium#CycleCompletions -1))

(fn codeium-dismiss []
  (vim.fn.codeium#Clear))

(fn config []
  (imap :<M-y> codeium-accept {: expr : silent})
  (imap :<M-n> codeium-next {: expr : silent})
  (imap :<M-p> codeium-prev {: expr : silent})
  (imap :<M-c> codeium-dismiss {: expr : silent}))

(use :Exafunction/codeium.vim {:event :BufEnter
                               :dependencies [:nvim-lua/plenary.nvim]
                               : config})
