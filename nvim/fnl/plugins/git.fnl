(import-macros {: nmap : use} :own.macros)
(local {: autoload} (require :nfnl.module))
(local {: ends-with} (require :own.string))
(local fs (autoload :nfnl.fs))
(local core (autoload :nfnl.core))
(local actions (autoload :telescope.actions))
(local builtin (autoload :telescope.builtin))
(local diff-view (autoload :diffview))
(local git-signs (autoload :gitsigns))
(local previewers (autoload :telescope.previewers))
(local putils (autoload :telescope.previewers.utils))
(local state (autoload :telescope.actions.state))
(local str (autoload :nfnl.string))
(local utils (autoload :telescope.utils))
(local neogit (autoload :neogit))

(set vim.g.fugitive_legacy_commands false)

(fn cmd [expression]
  (.. :<cmd> expression :<cr>))

(fn git-fixup [prompt-bufnr]
  "Creates a fixup using the selected commit. Assumes there are staged files to
  be committed."
  (let [current-picker (state.get_current_picker prompt-bufnr)
        selection (state.get_selected_entry)
        confirmation (vim.fn.input (.. "Fixup staged files into " selection.value "? [Y/n]"))]
    (if (= (string.lower confirmation) :y)
      (do
        (actions.close prompt-bufnr)
        (let [cmd [:git :commit :--fixup selection.value]
              (output ret) (utils.get_os_command_output cmd current-picker.cwd)
              results (if (= ret 0) output ["Nothing to fixup, have you staged your changes?"])]
          (vim.schedule
            #(vim.notify (table.concat results "\n") vim.log.levels.INFO {:title "git fixup" :icon :})))))))

(fn view-commit [target]
  "Open the selected commit using a fugitive command"
  (fn [prompt-bufnr]
    (let [selection (state.get_selected_entry)]
      (actions.close prompt-bufnr)
      (vim.cmd (.. target " " selection.value)))))

(fn yank-commit [propmt-bufnr]
  "Yank the selected commit into the default registry"
  (let [selection (state.get_selected_entry)]
    (actions.close propmt-bufnr)
    (vim.cmd (string.format "let @@='%s'" selection.value))))

(fn git-browse []
  "Open the selected commit in the platform hosting the remote. Depends on
  vim-fugitive's :GBrowse"
  (vim.cmd (.. "GBrowse " (. (state.get_selected_entry) :value))))

(fn git-commit-preview-fn [opts]
  (previewers.new_buffer_previewer
    {:get_buffer_by_name (fn [_ entry] entry.value)
     :define_preview (fn [self entry]
                       (putils.job_maker
                         [:git :--no-pager :show (.. entry.value "^!")]
                         self.state.bufnr
                         {:value entry.value
                          :bufname self.state.bufname
                          :cwd opts.cwd})
                       (putils.regex_highlighter self.state.bufnr :git))}))
(fn copy-remote-url [opts]
  (-> (if (= opts.range 2)
        (.. opts.line1 "," opts.line2 :GBrowse!)
        :GBrowse!)
      (vim.api.nvim_exec2 {:output true})
      (core.get :output)
      (vim.notify vim.log.levels.INFO {:title "Copied to clipboard"
                                       :icon :})))

;; Same as :GBrowse! but redirects the message to the notify API
(vim.api.nvim_create_user_command :GCopy copy-remote-url {:range true :nargs 0})

(fn git-log-mappings [_ map]
  (actions.select_default:replace (view-commit :Gtabedit))
  (map :i :<C-x> (view-commit :Gsplit))
  (map :n :<C-x> (view-commit :Gsplit))
  (map :i :<C-v> (view-commit :Gvsplit))
  (map :n :<C-v> (view-commit :Gvsplit))

  (map :i :<C-y> yank-commit)
  (map :n :<C-y> yank-commit)

  (map :i :<C-b> git-browse)
  (map :n :<C-b> git-browse)

  (map :i :<C-f> git-fixup)
  (map :n :<C-f> git-fixup)
  true)

(fn git-log [opts]
  (local git-commit-preview (utils.make_default_callable git-commit-preview-fn {}))
  (let [opts (or opts {})
        limit (or opts.limit 3000)
        command [:git :log
                 :--oneline :--decorate :-n limit
                 :--follow
                 :-- (or opts.path :.)]]
    (builtin.git_commits {:attach_mappings git-log-mappings
                          :previewer (git-commit-preview.new opts)
                          :git_command command})))

(fn git-buffer-log []
  (git-log {:path (vim.fn.expand :%:p)}))

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
        git-root (or vim.b.gitsigns_status_dict.root
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
  ; Write the current buffer and stage it
  (vim.cmd :Gwrite)

  ; If this is a fennel file, also stage the corresponding lua file
  (local current-file (vim.fn.expand :%:p))
  (if (ends-with current-file ".fnl")
      (vim.schedule #(let [lua-file (fs.fnl-path->lua-path current-file)]
                       (if (= (vim.fn.filereadable lua-file) 1)
                           (vim.cmd (.. "Git add " lua-file)))))))

(fn git-switch []
  (neogit.action :branch :branch/revision))

(fn config []
  (gmap :g (cmd "Neogit") "git status")
  (gmap :c (cmd "Neogit commit") "git commit")
  (gmap :s git-switch "git switch")
  (gmap :w git-write "write into the git tree")
  (gmap :r (cmd "Gread") "read from the git tree")
  (gmap :e (cmd "Gedit") "edit from the git tree") ; open the latest committed version of the current file
  (gmap :b (cmd "Git blame") "git blame")
  (gmap :d toggle-diff-view "toggle git diff")
  (gmap :l (cmd "Neogit log") "git log")
  (gmap :L git-buffer-log "current buffer's git log")
  (gmap :<space> #(files-in-commit :HEAD) "files in git HEAD")
  (gmap :f (cmd "Neogit fetch" "git fetch"))
  (gmap :p (cmd "Neogit pull" "git pull"))
  (gmap "hs" (cmd "Gitsigns stage_hunk") "stage git hunk")
  (gmap "hu" (cmd "Gitsigns undo_stage_hunk") "unstage git hunk")
  (gmap "hr" (cmd "Gitsigns reset_hunk") "reset git hunk")
  (gmap "hp" (cmd "Gitsigns preview_hunk") "preview git hunk")
  (gmap "hb" git-blame-line "blame current git hunk")

  (nmap "[h" (cmd "Gitsigns prev_hunk") {:desc "previous git hunk"
                                         :nowait true
                                         :silent true})
  (nmap "]h" (cmd "Gitsigns next_hunk") {:desc "next git hunk"
                                         :nowait true
                                         :silent true}))


[(use :lewis6991/gitsigns.nvim {:opts {:current_line_blame true}
                                :config true})

 (use :sindrets/diffview.nvim {:opts {:key_bindings {:disable_defaults false}}
                               :config true})

 (use :tpope/vim-git {:dependencies [:tpope/vim-fugitive
                                     :tpope/vim-rhubarb
                                     :nvim-lua/plenary.nvim
                                     :sindrets/diffview.nvim
                                     :lewis6991/gitsigns.nvim
                                     :norcalli/nvim-terminal.lua]
                      :event :VeryLazy
                      : config})

 (use :NeogitOrg/neogit {:dependencies [:nvim-lua/plenary.nvim
                                        :sindrets/diffview.nvim
                                        :nvim-telescope/telescope.nvim]
                         :opts {:disable_hint true
                                :fetch_after_checkout true
                                :graph_style :unicode
                                :remember_settings false
                                :notification_icon :
                                :recent_commit_count 15}
                         :config true
                         :cmd [:Neogit]})]
