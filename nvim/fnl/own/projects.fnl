(import-macros {: autocmd} :own.macros)
(local {: concat
        : kv-pairs
        : first
        : map
        : merge
        : reduce
        : spit
        : slurp} (require :nfnl.core))
(local {: take} (require :own.lists))
(local {: autoload : define} (require :nfnl.module))
(local {: sanitize-path} (require :own.helpers))
(local snacks (autoload :snacks))

(local M (define :own.projects))

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
  (spit projects-path (vim.json.encode (merge projects {project-path project}))))


(fn M.find-files [cwd]
  (snacks.picker.files {:dirs [(or cwd (vim.fn.getcwd))]}))

(fn format-project [path name]
  {:name (.. name " -> " (sanitize-path path 3))
   :action #(M.find-files path)
   :section "Recent Projects"})

(fn sort-projects [projects]
  (table.sort projects (fn [[_ a] [_ b]] (> a.timestamp b.timestamp)))
  projects)

(fn M.recent-projects [limit]
  "Returns a list of recent projects to be used by mini.starter"
  (->> (get-projects)
       (kv-pairs)
       (sort-projects)
       (take (or limit 30))
       (reduce (fn [acc [path project]]
                   (if project.visible
                         (concat acc [(format-project path project.name)])
                         acc))
               [])))

(fn pick-project [choice]
  (when choice (choice.action)))

(fn M.select-project []
  (vim.ui.select (M.recent-projects)
                 {:prompt "switch to a project"
                  :format_item (fn [{: name}] name)}
                 pick-project))

(fn M.project-list []
  (->> (get-projects)
       (kv-pairs)
       (sort-projects)
       (map first)))

(autocmd :User {:pattern :RooterChDir
                :callback #(add-project (vim.fn.getcwd))})

M
