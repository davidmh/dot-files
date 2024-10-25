(import-macros {: use : augroup : nmap} :own.macros)

(fn open-result-and-close-search []
  (nmap :<C-enter> :<localleader>o<localleader>c {:buffer true :remap true}))

(augroup :grug-far-keybindings [:FileType {:pattern :grug-far
                                           :callback open-result-and-close-search}])

(use :MagicDuck/grug-far.nvim {:opts {}
                               :cmd [:GrugFar]})
