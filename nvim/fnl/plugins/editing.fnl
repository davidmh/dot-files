(import-macros {: augroup
                : nmap
                : tx} :own.macros)

(fn fennel-rules []
  "Copies clojure's string definition from evaluating
  vim.api.nvim_g.switch_builtins.clojure_string"
  (set
    vim.b.switch_custom_definitions
    [{; string -> symbol
      "\"\\(\\k\\+\\)\"" ":\\1"
      ; symbol -> string
      ":\\(\\k\\+\\)" "\"\\1\"\\2"

      ; fn -> lambda
      :fn :λ
      ; lambda -> fn
      :λ :fn}]))

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

 (tx :mg979/vim-visual-multi {:keys [(tx :<c-n> {:mode [:n :v]})
                                     (tx "\\\\A" {:mode [:n :v]})]})

 (tx :AndrewRadev/switch.vim {:config config-switch
                              :event :VeryLazy})

 (tx :tommcdo/vim-exchange {:keys [:cx :cX (tx :X {:mode :v})]})

 (tx :junegunn/vim-easy-align {:keys [(tx :ga "<Plug>(EasyAlign)" {:mode [:x :n]})]})]
