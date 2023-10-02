(fn window-size [window-id]
  (* (vim.api.nvim_win_get_width window-id)
     (vim.api.nvim_win_get_height window-id)))

(fn get-largest-window-id []
  (let [windows-by-size {}]
    (each [_ window-id (pairs (vim.api.nvim_list_wins))]
      (tset windows-by-size (window-size window-id) window-id))
    (. windows-by-size (table.maxn windows-by-size))))

{: window-size
 : get-largest-window-id}
