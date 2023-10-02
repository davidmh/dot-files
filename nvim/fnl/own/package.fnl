(import-macros {: augroup : nmap} :own.macros)
(local {: autoload} (require :nfnl.module))

(local core (autoload :nfnl.core))
(local str (autoload :nfnl.string))

(fn get-package-paths [current-file]
  (let [paths []]
    (each [dir (vim.fs.parents current-file)]
      (when (= (vim.fn.filereadable (.. dir :/package.json)) 1)
        (table.insert paths (.. dir :/package.json))
        ; exit early at the cwd
        (when (= dir :./) (lua "return paths"))))
    paths))

(fn parse-package [package-path]
  (-> package-path
      (vim.fn.readfile "")
      (vim.fn.json_decode)))

(fn parse-scripts [package-path]
  (let [yarn-dir (-> package-path
                     (string.gsub (vim.fn.getcwd) "")
                     (string.gsub :package.json ""))
        keys (-> package-path
                 (parse-package)
                 (core.get :scripts)
                 (core.keys))]
    (vim.tbl_map (fn [key] (.. yarn-dir " | " key)) keys)))

(fn format-script [script]
  (let [parts (str.split script " | ")
        dir (core.first parts)
        cmd (core.second parts)]
    (.. "[" dir "] " cmd)))

(fn run-script [script]
  (when script
    (let [parts (str.split script " | ")
          dir (core.first parts)
          cmd (core.second parts)]
      (vim.cmd (.. "Dispatch -dir=" dir " yarn run " cmd))))) 

(fn yarn-select []
  (let [package-paths (get-package-paths (vim.fn.expand :%:p))
        scripts (vim.tbl_map parse-scripts package-paths)
        all (core.reduce core.concat [] scripts)]
    (vim.ui.select
      all
      {:prompt "yarn scripts"
       :format_item format-script}
      run-script)))

(fn setup-package-command []
  (let [has-paths (-> (vim.fn.expand :%:p)
                      (get-package-paths)
                      (core.first))]
    (when has-paths
      (nmap :<localleader>y yarn-select {:desc :yarn :buffer 0}))))

(augroup :package-command [[:BufEnter :BufNew] {:pattern :*
                                                :callback setup-package-command}])
