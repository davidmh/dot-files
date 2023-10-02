(import-macros {: augroup
                : nmap} :own.macros)

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

(augroup :custom-switches
         [:FileType {:pattern :fennel
                     :callback fennel-rules}]
         [:FileType {:pattern "css,less"
                     :callback css-rules}])

(nmap :!! "<Plug>(Switch)")
