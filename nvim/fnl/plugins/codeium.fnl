(import-macros {: use : imap} :own.macros)
(local {: autoload} (require :nfnl.module))
(local parpar (autoload :parpar))

(set vim.g.codeium_filetypes {:zsh false
                              :TelescopePropmt false})
(set vim.g.codeium_enabled true)
(set vim.g.codeium_no_map_tab true)

(local expr true)
(local silent true)

(fn codeium-accept []
  (vim.schedule parpar.pause)
  (vim.fn.codeium#Accept))

(fn codeium-next []
  (vim.fn.codeium#CycleCompletions 1))

(fn codeium-prev []
  (vim.fn.codeium#CycleCompletions -1))

(fn codeium-dismiss []
  (vim.fn.codeium#Clear))

(use :Exafunction/codeium.vim {:event :InsertEnter
                               :dependencies [:nvim-lua/plenary.nvim]
                               :init #(set vim.g.codeium_disable_bindings true)
                               :config (fn []
                                          (imap :<M-y> codeium-accept {: expr : silent})
                                          (imap :<M-n> codeium-next {: expr : silent})
                                          (imap :<M-p> codeium-prev {: expr : silent})
                                          (imap :<M-c> codeium-dismiss {: expr : silent}))})
