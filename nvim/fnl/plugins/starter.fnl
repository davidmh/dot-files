(import-macros {: use} :own.macros)
(local {: autoload} (require :nfnl.module))
(local {: get : first} (require :nfnl.core))
(local {: sanitize-path} (require :own.helpers))
(local mini-starter (autoload :mini.starter))
(local projects (autoload :own.projects))

(math.randomseed (os.time))

(local quotes ["vim is only free if your time has no value."
               "Eat right, stay fit, and die anyway."
               "Causes moderate eye irritation."
               "May cause headaches."
               "And now for something completely different."
               "What are we breaking today?"
               "Oh good, it's almost bedtime."])

(fn format-recent [{: name : action : section}]
  (let [path (string.gsub action "edit " "")]
     {:name (.. (-> name (vim.split " ") (first))
                " -> "
                (sanitize-path path 3))
      : action
      : section}))

(fn recent-entries []
  (->> ((mini-starter.sections.recent_files 15 false true))
       (vim.tbl_map format-recent)))

(fn config []
  (mini-starter.setup {:header (->> quotes
                                    (length)
                                    (math.random)
                                    (get quotes))
                       :items [(recent-entries)
                               (projects.recent-projects 10)]
                       :footer ""}))

(fn open-starter []
  (config) ; to refresh the items
  (mini-starter.open))

(use :echasnovski/mini.starter {:version :*
                                :event :VimEnter
                                :config config
                                :keys [(use :<localleader>s open-starter {:desc "Open Starter"})]})
