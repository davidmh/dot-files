(module own.plugin.flatten
  {autoload {nvim aniseed.nvim
             core aniseed.core
             flatten flatten}})

(defn- window-size [window-id]
  (* (nvim.win_get_width window-id)
     (nvim.win_get_height window-id)))

(defn- get-largest-window-id []
  (let [windows-by-size {}]
    (each [_ window-id (pairs (nvim.list_wins))]
      (tset windows-by-size (window-size window-id) window-id))
    (. windows-by-size (table.maxn windows-by-size))))

(defn- open-in-largest-window [files]
  (let [window-id (get-largest-window-id)
        file-name (core.get-in files [1 :fname])
        bufnr (vim.fn.bufnr file-name)]
    (nvim.win_set_buf window-id bufnr)
    (nvim.set_current_win window-id)))

;; assumes the diff is comparing only two files, works for now
(defn- open-diff-in-tab [files]
  (vim.cmd (.. "tabedit " (core.get-in files [1 :fname])))
  (vim.cmd (.. "botright vertical diffsplit " (core.get-in file-paths [2 :fname]))))

(def- diff-mode #(vim.tbl_contains (or $1 []) :-d))

(defn- router [files argv]
  (if (diff-mode argv)
    (open-diff-in-tab files)
    (open-in-largest-window files)))

(flatten.setup {:window {:open router}
                :callbacks {:should_block diff-mode}
                :nest_if_no_args true})
