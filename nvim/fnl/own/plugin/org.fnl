(module own.plugin.org
  {autoload {nvim aniseed.nvim
             core aniseed.core
             orgmode orgmode
             org-bullets org-bullets}})

(orgmode.setup
  {:org_agenda_files "~/Documents/org/*"
   :org_default_notes_file "~/Documents/org/index.org"
   :notifications {:enabled true
                   :cron_enabled false
                   :repeater_reminder_time false
                   :deadline_warning_reminder_time false
                   :reminder_time 5
                   :deadline_reminder true
                   :scheduled_reminder true
                   :notifier notifier}
   :win_split_mode (fn [name]
                     (let [bufnr (nvim.create_buf false true)
                           fill 0.8
                           width (math.floor (* vim.o.columns fill))
                           height (math.floor (* vim.o.lines fill))
                           row (-> vim.o.lines (- height) (/ 2) (- 1) math.floor)
                           col (-> vim.o.columns (- width) (/ 2) math.floor)]
                       (nvim.buf_set_name bufnr name)
                       (nvim.open_win bufnr true {:relative :editor
                                                  :width width
                                                  :height height
                                                  :row row
                                                  :col col
                                                  :style :minimal
                                                  :border :rounded})))})

(org-bullets.setup)

(defn- type-to-severity [task-type]
  (core.get {:DEADLINE vim.diagnostic.severity.WARN
             :SCHEDULED vim.diagnostic.severity.INFO}
            task-type))

(defn- notifier [tasks]
   (each [i task (ipairs tasks)]
     (vim.notify
       task.title
       (type-to-severity task.type)
       {:title [task.type task.humanized_duration]
        :keep (fn [] true)})))

(defn options []
  (set nvim.bo.textwidth 80))

(do
  (nvim.create_augroup :orgmode-options {:clear true})
  (nvim.create_autocmd :FileType {:pattern :org
                                  :callback options
                                  :group :orgmode-options}))
