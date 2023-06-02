(module own.plugin.org
  {autoload {nvim aniseed.nvim
             core aniseed.core
             org-mode orgmode
             org-bullets org-bullets}})

(org-mode.setup {:org_agenda_files ["~/Documents/org/*"]
                 :org_default_notes_file "~/Documents/org/refile.org"
                 :org_hide_emphasis_markers true})

(org-bullets.setup)

(defn- org-settings []
  (set vim.wo.conceallevel 3)
  (set vim.wo.foldenable false))

(nvim.create_augroup :org-settings {:clear true})

(nvim.create_autocmd :BufRead {:group :org-settings
                               :pattern :*.org
                               :callback org-settings})
