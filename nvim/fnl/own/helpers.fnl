(local {: define} (require :nfnl.module))
(local {: get-in} (require :nfnl.core))

(local M (define :own.helpers))

(fn M.window-size [window-id]
  (* (vim.api.nvim_win_get_width window-id)
     (vim.api.nvim_win_get_height window-id)))

(fn M.get-largest-window-id []
  (let [windows-by-size {}]
    (each [_ window-id (pairs (vim.api.nvim_list_wins))]
      (tset windows-by-size (M.window-size window-id) window-id))
    (. windows-by-size (table.maxn windows-by-size))))

(fn M.get-term []
  "
  Get the channel, window and buffer for the first terminal found in the
  available windows.
  "
  (each [_ window (pairs (vim.api.nvim_list_wins))]
    (local buffer (vim.api.nvim_win_get_buf window))
    (local channel (get-in vim.bo [buffer :channel]))
    (when (not= channel 0)
      (lua "return { channel = channel, buffer = buffer, window = window }"))))

(fn M.sanitize-path [path size]
  (-> path
      (string.gsub vim.env.HOME "~")
      (vim.fn.pathshorten (or size 2))))

(fn M.past-due? [iso-date]
  (vim.validate :iso-date iso-date :string)
  (local (year month day) (iso-date:match "(%d+)-(%d+)-(%d+)"))
  (>= (os.time)
      (os.time {: year : month : day})))

(fn M.get-lines-from-visual-range []
  (local region (vim.fn.getregionpos (vim.fn.getpos "v")
                                     (vim.fn.getpos ".")))

  (local start-line (- (get-in region [1 1 2]) 1))
  (local end-line (get-in region [(length region) 1 2]))

  (vim.api.nvim_buf_get_lines 0 start-line end-line true))

M
