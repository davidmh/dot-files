(module own.plugin.switch
  {autoload {nvim aniseed.nvim
             notify notify}})

(set nvim.g.switch_mapping :!)

(defn- fennel-rules []
  "Copies clojure's string definition from evaluating
  nvim.g.switch_builtins.clojure_string"
  (set
    nvim.b.switch_custom_definitions
    [{; string -> symbol
      "\"\\(\\k\\+\\)\"" ":\\1"
      ; symbol -> string
      ":\\(\\k\\+\\)" "\"\\1\"\\2"}]))

(defn- css-rules []
  "Fix rules pasted from javascript notation"
  (set
    nvim.b.switch_custom_definitions
    [{; properties: backgroundColor: -> background-color:
      "\\(\\<\\l\\{1,\\}\\)\\(\\u\\l*\\):" "\\1-\\l\\2:"}]))

(nvim.create_augroup :custom-switches {:clear true})
(nvim.create_autocmd :FileType {:pattern :fennel
                                :callback fennel-rules
                                :group :custom-switches})
(nvim.create_autocmd :FileType {:pattern "css,less"
                                :callback css-rules
                                :group :custom-switches})
