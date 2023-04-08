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

(defn- open-in-largest-window [bufs]
  (let [window-id (get-largest-window-id)]
    (nvim.win_set_buf window-id (. bufs 1))
    (nvim.set_current_win window-id)))

;; assumes the diff is comparing only two files, works for now
(defn- open-diff-in-tab [bufs]
  (vim.cmd (.. "tabedit " (nvim.buf_get_name (. bufs 1))))
  (vim.cmd (.. "botright vertical diffsplit " (nvim.buf_get_name (. bufs 2)))))

(defn- router [bufs argv]
  (if (vim.tbl_contains argv :-d)
    (open-diff-in-tab bufs)
    (open-in-largest-window bufs)))

(flatten.setup {:window {:open router}})
