(import-macros {: augroup} :own.macros)

(local org-mode (require :orgmode))
(local org-bullets (require :org-bullets))

(org-mode.setup {:org_agenda_files ["~/Documents/org/*"]
                 :org_default_notes_file "~/Documents/org/refile.org"
                 :org_hide_emphasis_markers true})

(org-bullets.setup)

(fn org-settings []
  (set vim.wo.conceallevel 3)
  (set vim.wo.foldenable false))

(augroup :org-settings [:BufRead {:pattern :*.org
                                  :callback org-settings}])
