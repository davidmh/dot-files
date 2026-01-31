(local {: define} (require :nfnl.module))

(local M (define :own.helpers))

(fn M.window-size [window-id]
  (* (vim.api.nvim_win_get_width window-id)
     (vim.api.nvim_win_get_height window-id)))

(fn M.get-largest-window-id []
  (let [windows-by-size {}]
    (each [_ window-id (pairs (vim.api.nvim_list_wins))]
      (tset windows-by-size (M.window-size window-id) window-id))
    (. windows-by-size (table.maxn windows-by-size))))

(fn M.sanitize-path [path size]
  (-> path
      (string.gsub vim.env.HOME "~")
      (vim.fn.pathshorten (or size 2))))

(fn M.past-due? [iso-date]
  (vim.validate :iso-date iso-date :string)
  (local (year month day) (iso-date:match "(%d+)-(%d+)-(%d+)"))
  (>= (os.time)
      (os.time {: year : month : day})))

M
