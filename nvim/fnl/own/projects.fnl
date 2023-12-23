(import-macros {: autocmd} :own.macros)
(local {: concat
        : kv-pairs
        : merge
        : reduce
        : spit
        : slurp} (require :nfnl.core))
(local {: autoload} (require :nfnl.module))
(local {: sanitize-path} (require :own.helpers))
(local t (autoload :telescope.builtin))
(local Path (autoload :plenary.path))

(local projects-path (.. (vim.fn.stdpath :state) "/projects.json"))

(vim.schedule #(if (= (vim.fn.filereadable projects-path) 0)
                   (spit projects-path "{}")))

(fn get-projects []
  (vim.json.decode (slurp projects-path)))

(fn add-project [project-path]
  ;; Some special buffers may yield a cwd that does not exist
  (when (string.match project-path ::)
      (lua :return))

  (local projects (get-projects))
  (local name (vim.fn.fnamemodify project-path ":t"))
  (local project {:name name
                  :timestamp (os.time)
                  :visible true})
  (spit projects-path (vim.json.encode (merge {project-path project} projects))))


(fn find-files [cwd]
  (t.find_files {:cwd (or cwd (vim.fn.getcwd))
                 :find_command [:fd
                                :--hidden
                                :--type :f
                                :--exclude :.git]}))

(fn format-project [path name]
  {:name (.. name " -> " (sanitize-path path 3))
   :action #(find-files path)
   :section "Recent Projects"})

(fn sort-projects [projects]
  (table.sort projects (fn [[_ a] [_ b]] (> a.timestamp b.timestamp)))
  projects)

(fn recent-projects []
  "Returns a list of recent projects to be used by mini.starter"
  (->> (get-projects)
       (kv-pairs)
       (sort-projects)
       (reduce (fn [acc [path project]]
                   (if project.visible
                         (concat acc [(format-project path project.name)])
                         acc))
               [])))

(fn pick-project [choice]
  (when choice (choice.action)))

(fn select-project []
  (vim.ui.select (recent-projects)
                 {:prompt "switch to a project"
                  :format_item (fn [{: name}] name)}
                 pick-project))

(autocmd :User {:pattern :RooterChDir
                :callback #(add-project (vim.fn.getcwd))})

{: find-files
 : recent-projects
 : select-project}
