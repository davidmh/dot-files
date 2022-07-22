(module own.plugin.git
  {autoload {actions telescope.actions
             config telescope.config
             core aniseed.core
             diff-view diffview
             finders telescope.finders
             git-signs gitsigns
             make-entry telescope.make_entry
             nvim aniseed.nvim
             pickers telescope.pickers
             previewers telescope.previewers
             putils telescope.previewers.utils
             state telescope.actions.state
             str aniseed.string
             utils telescope.utils
             wk which-key}})

(git-signs.setup {:current_line_blame false
                  :yadm {:enable false}})

(diff-view.setup {:key_bindings {:disable_defaults false}})

(defn- cmd [expression description]
  [(.. :<cmd> expression :<cr>) description])

(defn- git-fixup [prompt-bufnr]
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
          (vim.fn.setqflist results :r {:title (str.join " " cmd)}))))))

(defn- view-commit [target]
  "Open the selected commit using a fugitive command"
  (fn [prompt-bufnr]
    (let [selection (state.get_selected_entry)]
      (actions.close prompt-bufnr)
      (vim.cmd (.. target " " selection.value)))))

(defn- yank-commit [propmt-bufnr]
  "Yank the selected commit into the default registry"
  (let [selection (state.get_selected_entry)]
    (actions.close propmt-bufnr)
    (vim.cmd (string.format "let @@='%s'" selection.value))))

(defn- git-browse []
  "Open the selected commit in the platform hosting the remote. Depends on
  vim-fugitive's :GBrowse"
  (vim.cmd (.. :GBrowse (. (state.get_selected_entry) :value))))

(defn- git-commit-preview-fn [opts]
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

(def- git-commit-preview (utils.make_default_callable git-commit-preview-fn {}))

(defn- git-log-mappings [_ map]
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

(defn- git-log [opts]
  (let [opts (if (core.nil? opts) {} opts)
        path (core.get opts :path ".")
        limit (core.get opts :limit 2000)
        revision-range (core.get opts :revision_range :HEAD)
        path-in-title (if (core.nil? (core.get opts :path)) "" (.. " --  " path))
        results (utils.get_os_command_output
                  [:git :log :--pretty=oneline :--abbrev-commit (.. "-n" limit) revision-range "--" path]
                  (core.get opts :cwd))
        picker (pickers.new opts {:prompt_title (.. "git log" path-in-title)
                                  :finder (finders.new_table {:results results
                                                              :entry_maker (make-entry.gen_from_git_commits opts)})
                                  :previewer (git-commit-preview.new opts)
                                  :sorter (config.values.file_sorter opts)
                                  :attach_mappings git-log-mappings})]
    (picker:find)))

(defn- git-buffer-log []
  (git-log {:path (vim.fn.expand :%)}))

(defn- git-blame-line []
  (git-signs.blame_line true))

(defn- toggle-diff-view []
  (let [buffer-prefix (-> (nvim.buf_get_name 0)
                          (str.split ::)
                          (core.first))]
    (if (= buffer-prefix :diffview)
      (diff-view.close)
      (diff-view.open))))

(wk.register
  {:g {:name :git
       :s (cmd :Git "git status")
       :c (cmd "Telescope git_branches" "checkout branch")
       :w (cmd "Gwrite" "write into the git tree")
       :r (cmd "Gread" "read from the git tree")
       :e (cmd "Gedit" "edit from the git tree") ; open the latest committed version of the current file
       :b (cmd "Git blame" "blame")
       :d [toggle-diff-view "view diff"]
       :l [git-log "git log"]
       :L [git-buffer-log "current buffer's git log"]
       :B (cmd "'<,'>GBrowse" "open in remote service")
       :f (cmd :GFixup "fixup staged changes")
       :h {:name "hunk"
           "[" (cmd "Gitsigns prev_hunk" :prev)
           "]" (cmd "Gitsigns next_hunk" :next)
           :s (cmd "Gitsigns stage_hunk" :stage)
           :u (cmd "Gitsigns undo_stage_hunk" :unstage)
           :r (cmd "Gitsigns reset_hunk" :reset)
           :p (cmd "Gitsigns preview_hunk" :preview)
           :b [git-blame-line :blame]}}}
  {:prefix :<leader>})
