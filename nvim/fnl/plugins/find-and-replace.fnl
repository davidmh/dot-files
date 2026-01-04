(import-macros {: tx : augroup : nmap} :own.macros)
(local {: autoload} (require :nfnl.module))
(local grug-far (autoload :grug-far))

(fn open-quickfix-and-close-grug []
  (local instance (grug-far.get_instance 0))
  (instance:open_quickfix)
  (instance:close)
  (vim.cmd.cfirst))

(augroup :grug-far-keybindings
         [:FileType {:pattern :grug-far
                     :callback #(nmap :<C-enter>
                                      open-quickfix-and-close-grug
                                      {:buffer true})}])

(tx :MagicDuck/grug-far.nvim {:opts {}
                              :cmd [:GrugFar]
                              :keys [(tx :<localleader>g :<cmd>GrugFar<cr> {:desc :grug-far :mode :n})]})
