(import-macros {: augroup
                : map
                : nmap
                : use} :own.macros)

(fn fennel-rules []
  "Copies clojure's string definition from evaluating
  vim.api.nvim_g.switch_builtins.clojure_string"
  (set
    vim.b.switch_custom_definitions
    [{; string -> symbol
      "\"\\(\\k\\+\\)\"" ":\\1"
      ; symbol -> string
      ":\\(\\k\\+\\)" "\"\\1\"\\2"}]))

(fn css-rules []
  "Fix rules pasted from javascript notation"
  (set
    vim.b.switch_custom_definitions
    [{; properties: backgroundColor: -> background-color:
      "\\(\\<\\l\\{1,\\}\\)\\(\\u\\l*\\):" "\\1-\\l\\2:"}]))

(fn config-switch []
  (nmap :!! "<Plug>(Switch)" {:silent true})
  (augroup :custom-switches
           [:FileType {:pattern :fennel :callback fennel-rules}]
           [:FileType {:pattern "css,less" :callback css-rules}]))

(fn config-easy-align []
  (map [:x :n] :ga "<Plug>(EasyAlign)"))

(fn config-mundo []
  (set vim.o.undofile true)
  (set vim.o.undodir (.. (vim.fn.stdpath "data") "/undo")))

[:junegunn/vim-slash
 :mg979/vim-visual-multi

 (use :chrishrb/gx.nvim {:keys [:gx]
                         :config true})

 ;; open files from a terminal buffer in the current instance
 (use :willothy/flatten.nvim {:opts {:window {:open :smart}
                                     :callbacks {:should_block #(vim.tbl_contains (or $1 []) :-d)}
                                     :nest_if_no_args true}
                              :config true})

 (use :AndrewRadev/switch.vim {:config config-switch
                               :event :VeryLazy})

 (use :tommcdo/vim-exchange {:keys [:cx :cX (use :X {:mode :v})]})

 (use :junegunn/vim-easy-align {:config config-easy-align
                                :keys [:ga]})

 (use :simnalamburt/vim-mundo {:config config-mundo
                               :event :VeryLazy})

 (use :dhruvasagar/vim-table-mode {:ft :markdown})]
