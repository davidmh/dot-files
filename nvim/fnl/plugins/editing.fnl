(import-macros {: augroup
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

[:junegunn/vim-slash

 (use :mg979/vim-visual-multi {:keys [(use :<c-n> {:mode [:n :v]})
                                      (use "\\\\A" {:mode [:n :v]})]})

 ;; open files from a terminal buffer in the current instance
 (use :willothy/flatten.nvim {:opts {}})

 (use :AndrewRadev/switch.vim {:config config-switch
                               :event :VeryLazy})

 (use :tommcdo/vim-exchange {:keys [:cx :cX (use :X {:mode :v})]})

 (use :junegunn/vim-easy-align {:keys [(use :ga "<Plug>(EasyAlign)" {:mode [:x :n]})]})

 (use :wakatime/vim-wakatime {:lazy false})]
