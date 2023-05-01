(module own.plugin.flatten
  {autoload {nvim aniseed.nvim
             flatten flatten}})

(defn- window-size [window-id]
  (* (nvim.win_get_width window-id)
     (nvim.win_get_height window-id)))

(defn- get-largest-window-id []
  (let [windows-by-size {}]
    (each [_ window-id (pairs (nvim.list_wins))]
      (tset windows-by-size (window-size window-id) window-id))
    (. windows-by-size (table.maxn windows-by-size))))

(defn- open-in-largest-window [file-paths]
  (let [window-id (get-largest-window-id)
        bufnr (vim.fn.bufnr (. file-paths 1))]
    (nvim.win_set_buf window-id bufnr)
    (nvim.set_current_win window-id)))

;; assumes the diff is comparing only two files, works for now
(defn- open-diff-in-tab [file-paths]
  (vim.cmd (.. "tabedit " (. file-paths 1)))
  (vim.cmd (.. "botright vertical diffsplit " (. file-paths 2))))

(def- diff-mode #(vim.tbl_contains (or $1 []) :-d))

(defn- router [file-paths argv]
  (if (diff-mode argv)
    (open-diff-in-tab file-paths)
    (open-in-largest-window file-paths)))

(flatten.setup {:window {:open router}
                :callbacks {:should_block diff-mode}
                :nest_if_no_args true})
