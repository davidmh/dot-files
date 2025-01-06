(import-macros {: nmap : vmap : use} :own.macros)
(local {: autoload} (require :nfnl.module))
(local fs (autoload :nfnl.fs))
(local core (autoload :nfnl.core))
(local diff-view (autoload :diffview))
(local git-signs (autoload :gitsigns))
(local str (autoload :nfnl.string))

(set vim.g.fugitive_legacy_commands false)

(fn git-error [result]
  (vim.notify result.stderr
              vim.log.levels.ERROR
              {:icon :󰊢 :title "git error"}))

(fn git [...]
  (local process (vim.system [:git ...] {:text true}))
  (local result (process:wait))
  (if (= result.stderr "")
    (str.trim result.stdout)
    (git-error result)))

(fn git-remote-base-url []
  (let [remote (git :remote :get-url :origin)
        base-url (match (str.split remote ::)
                  ["git@github.com" path] (.. "https://github.com/" path)
                  ["https"] remote)]
      (.. (string.gsub base-url ".git$" ""))))

; Open the current file's remote URL
(fn git-url []
  (let [repo-root (git :rev-parse :--show-toplevel)
        absolute-path (vim.fn.expand :%:p)
        relative-path (string.sub absolute-path (+ 2 (length repo-root)))
        commit (git :rev-parse :HEAD)]
      (.. (git-remote-base-url) "/blob/" commit "/" relative-path)))

(fn gitsigns-commit-url [path]
  (local remote-url (git-remote-base-url))
  (local parts (str.split path :/))
  (local commit (core.last parts))
  (.. remote-url "/commit/" commit))

(fn neogit-commit-url []
  ; The first line containst the commit sha in the format:
  ; Commit <sha>
  (let [commit (-> (vim.fn.getline 1)
                   (str.split " ")
                   (core.second))]
    (.. (git-remote-base-url) "/commit/" commit)))

(fn git-url-with-range [opts]
  (if (= opts.range 2)
    (.. (git-url) "#L" opts.line1 "-L" opts.line2)
    (git-url)))

(fn cmd [expression]
  (.. :<cmd> expression :<cr>))

(fn copy-remote-url [opts]
  (local url (git-url-with-range opts))
  (vim.fn.setreg :+ url)
  (vim.notify url vim.log.levels.INFO {:title "Copied to clipboard"
                                       :icon :}))

(fn open-git-url [opts]
  (local path (vim.fn.expand :%:p))
  (vim.ui.open (match [vim.bo.ft]
                  [:git] (gitsigns-commit-url path)
                  [:NeogitCommitView] (neogit-commit-url)
                  [] (git-url-with-range opts))))

;; Copy the file or range remote URL to the system clipboard
(vim.api.nvim_create_user_command :GCopy copy-remote-url {:range true :nargs 0})

(fn git-blame-line []
  (git-signs.blame_line true))

(fn toggle-diff-view []
  (let [buffer-prefix (-> (vim.api.nvim_buf_get_name 0)
                          (str.split ::)
                          (core.first))]
    (if (= buffer-prefix :diffview)
      (diff-view.close)
      (diff-view.open))))

(fn files-in-commit [ref]
  (let [output (vim.fn.systemlist [:git :show :--name-only :--oneline ref])
        title (core.first output)
        git-root (or (core.get-in vim.b [:gitsigns_status_dict :root])
                     (vim.trim (vim.fn.system "git rev-parse --show-toplevel")))
        files (->> output
                  (core.rest)
                  (vim.tbl_filter #(not (core.empty? $1))))
        next-commit (->> (vim.fn.systemlist [:git :log :-n 1 :--oneline (.. ref :^)])
                         (core.first)
                         (.. "next: "))
        next-ref (-> next-commit
                     (str.split " ")
                     (core.second))]
    (table.insert files next-commit)
    (vim.ui.select files {:prompt title} #(do
                                            (if (= $1 nil) (lua :return))
                                            (if (= $1 next-commit)
                                              (files-in-commit next-ref)
                                              (vim.cmd (.. "edit " git-root "/" $1)))))))

(fn gmap [keymap callback desc]
  (nmap (.. :<leader>g keymap) callback {:desc desc
                                         :nowait true}))

(fn git-write []
  (local current-file (vim.fn.expand :%:p))

  ; Write the current buffer and stage it
  (vim.cmd :write)
  (git :add :-- current-file)

  ; If this is a fennel file, also stage the corresponding lua file
  (if (vim.endswith current-file ".fnl")
      (vim.schedule #(let [lua-file (fs.fnl-path->lua-path current-file)]
                       (if (= (vim.fn.filereadable lua-file) 1)
                           (git :add :-- lua-file))))))

(fn git-read []
  ;; A naive port of vim-fugitive's :Gread
  ;; Reads the content of the current file from the git HEAD and updates the
  ;; buffer without saving it to disk.
  (let [current-file (vim.fn.expand :%)
        content (git :show (.. :HEAD:./ current-file))]
    (vim.api.nvim_buf_set_lines 0 0 -1 true (str.split content "\n"))))

(fn config []
  (gmap :g (cmd "Neogit") "git status")
  (gmap :c (cmd "Neogit commit") "git commit")
  (gmap :w git-write "write into the git tree")
  (gmap :r git-read "read from the git tree")
  (gmap :b (cmd "Git blame") "git blame")
  (gmap :- (cmd "Neogit branch") "git branch")
  (gmap :d toggle-diff-view "toggle git diff")
  (gmap :l (cmd "Neogit log") "git log")
  (gmap :L (cmd "NeogitLogCurrent") "current buffer's git log")
  (gmap :<space> #(files-in-commit :HEAD) "files in git HEAD")
  (gmap :f (cmd "Neogit fetch" "git fetch"))
  (gmap :p (cmd "Neogit pull" "git pull"))
  (gmap :B (cmd "GBrowse") "browse")
  (gmap "hs" (cmd "Gitsigns stage_hunk") "stage git hunk")
  (gmap "hu" (cmd "Gitsigns undo_stage_hunk") "unstage git hunk")
  (gmap "hr" (cmd "Gitsigns reset_hunk") "reset git hunk")
  (gmap "hp" (cmd "Gitsigns preview_hunk") "preview git hunk")
  (gmap "hb" git-blame-line "blame current git hunk")

  (vmap :<leader>gl (cmd "'<,'>GBrowse") {:desc "open selection in the remote service"
                                          :nowait true
                                          :silent true})
  (vmap :<leader>gl (cmd "'<,'>NeogitLogCurrent") {:desc "current's selection git log"
                                                   :nowait true
                                                   :silent true})

  (nmap "[h" (cmd "Gitsigns prev_hunk") {:desc "previous git hunk"
                                         :nowait true
                                         :silent true})
  (nmap "]h" (cmd "Gitsigns next_hunk") {:desc "next git hunk"
                                         :nowait true
                                         :silent true}))


[(use :lewis6991/gitsigns.nvim {:opts {:current_line_blame true
                                       :signcolumn true}
                                :config true})

 (use :sindrets/diffview.nvim {:opts {:key_bindings {:disable_defaults false}}
                               :config true})

 (use :tpope/vim-git {:dependencies [:nvim-lua/plenary.nvim
                                     :sindrets/diffview.nvim
                                     :lewis6991/gitsigns.nvim]
                      :event :VeryLazy
                      : config})

 (use :tpope/vim-fugitive {:dependencies [:tpope/vim-rhubarb]})

 (use :NeogitOrg/neogit {:dependencies [:nvim-lua/plenary.nvim
                                        :sindrets/diffview.nvim
                                        :nvim-telescope/telescope.nvim]
                         :opts {:disable_hint true
                                :fetch_after_checkout true
                                :graph_style :unicode
                                :remember_settings false
                                :notification_icon :
                                :recent_commit_count 15}
                         :cmd [:Neogit :NeogitLogCurrent]})]
