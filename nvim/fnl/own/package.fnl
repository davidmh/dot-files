(module own.package
  {autoload {core aniseed.core
             str aniseed.string
             wk which-key}})

(defn- get-package-paths [current-file]
  (let [paths []]
    (each [dir (vim.fs.parents current-file)]
      (when (= (vim.fn.filereadable (.. dir :/package.json)) 1)
        (table.insert paths (.. dir :/package.json))
        ; exit early at the cwd
        (when (= dir :./) (lua "return paths"))))
    paths))

(defn- parse-package [package-path]
  (-> package-path
      (vim.fn.readfile "")
      (vim.fn.json_decode)))

(defn- parse-scripts [package-path]
  (let [yarn-dir (-> package-path
                     (string.gsub (vim.fn.getcwd) "")
                     (string.gsub :package.json ""))
        keys (-> package-path
                 (parse-package)
                 (core.get :scripts)
                 (core.keys))]
    (vim.tbl_map (fn [key] (.. yarn-dir " | " key)) keys)))

(defn- format-script [script]
  (let [parts (str.split script " | ")
        dir (core.first parts)
        cmd (core.second parts)]
    (.. "[" dir "] " cmd)))

(defn- run-script [script]
  (when script
    (let [parts (str.split script " | ")
          dir (core.first parts)
          cmd (core.second parts)]
      (vim.cmd (.. "Dispatch -dir=" dir " yarn run " cmd))))) 

(defn- yarn-select []
  (let [package-paths (get-package-paths (vim.fn.expand :%))
        scripts (vim.tbl_map parse-scripts package-paths)
        all (core.reduce core.concat [] scripts)]
    (vim.ui.select
      all
      {:prompt "yarn scripts"
       :format_item format-script}
      run-script)))

(defn- setup-package-command []
  (let [has-paths (-> (vim.fn.expand :%)
                      (get-package-paths)
                      (core.first))]
    (when has-paths
      (wk.register {:y [yarn-select :yarn]}
                   {:prefix :<localleader>
                    :buffer 0}))))

(vim.api.nvim_create_augroup :package-command {:clear true})

(defn setup []
  (vim.api.nvim_create_autocmd
    [:BufEnter :BufCreate]
    {:callback setup-package-command
     :group :package-command}))
